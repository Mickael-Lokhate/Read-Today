//
//  BookDetailsViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 11/01/2021.
//

import UIKit
import FirebaseFirestore
import AlamofireImage

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var toReadLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var pagesPerFrequencyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!
    
    var book: Book?
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = book {
            getDataFromFirestore(with: db)
            DispatchQueue.main.async {
                self.setDetails(with: book)
            }
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromFirestore(with: db)
        if let book = book {
            DispatchQueue.main.async {
                self.setDetails(with: book)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddPages" {
            let destinationVC = segue.destination as! AddPagesController
            destinationVC.selectedBook = book
        }
    }
    
    private func getDataFromFirestore(with db: Firestore) {
        if let book = book {
            let ref = db.collection("books").document(book.bookID)
            
            ref.getDocument { (doc, error) in
                if let error = error {
                    print("Error getting documets : \(error)")
                } else {
                    if let doc = doc {
                        if let datas = doc.data() {
                            self.addBook(datas, doc.documentID)
                        }
                    }
                }
            }
        }
    }
    
    private func setDetails (with book: Book)
    {
        if let url = URL(string: book.imageLink) {
            bookImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
        }
        
        titleLabel.text = book.title
        descriptionLabel.text = book.description
        if (!book.isFinished)
        {
            toReadLabel.text = "Il vous reste \(book.pagesLeftToRead) pages à lire."
            
        } else {
            toReadLabel.text = "Vous avez finis le livre."
            finishedButton.isEnabled = false
            finishedButton.isUserInteractionEnabled = false
        }
        totalPagesLabel.text = "Il y a \(book.totalPages) pages."
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .none
        dateFormat.dateStyle = .medium
        if let local = Locale.current.languageCode {
            dateFormat.locale = Locale(identifier: local)
            if (book.isFinished){
                dateLabel.text = "Terminé le : \(dateFormat.string(from: book.dateOfEndReading))"
            } else {
                dateLabel.text = "Terminé avant : \(dateFormat.string(from: book.dateOfEndReading))"
            }
            
        } else {
            if book.isFinished {
                dateLabel.text = "Terminé le : \(book.dateOfEndReading.description)"
            } else {
                dateLabel.text = "Terminé avant : \(book.dateOfEndReading.description)"
            }
        }
        
        frequencyLabel.text = "Fréquence de lecture : \(book.readingFrequency)"
        pagesPerFrequencyLabel.text = "Pages à lire : \(book.pagesToReadByFrequency)"
    }
    
    private func addBook(_ data: [String: Any], _ docID: String){
        let title = data["title"] as! String
        let author = data["author"] as! String
        let totalPages = data["totalPage"] as! Int
        let description = data["description"] as! String
        let publisher = data["publisher"] as! String
        let publishedDate = data["publishedDate"] as! String
        let imageLink = data["imageLink"] as! String
        let pagesAlreadyRead = data["pagesAlreadyRead"] as! Int
        let readingFrequency = data["readingFrequency"] as! String
        let pagesPerFrequency = data["pagesPerFrequency"] as! Int
        let tmpDate = data["dateOfEndReading"] as! Timestamp
        let dateOfEndReading = Date(timeIntervalSince1970: TimeInterval(tmpDate.seconds))
        
        let newBook = Book(title: title,
                           author: author,
                           totalPages: totalPages,
                           description: description,
                           publisher: publisher,
                           publishedDate: publishedDate,
                           imageLink: imageLink,
                           pagesAlreadyRead: pagesAlreadyRead,
                           readingFrequency: readingFrequency,
                           pagesToReadByFrequency: pagesPerFrequency,
                           dateOfEndReading: dateOfEndReading,
                           bookID: docID)
        book = newBook
        
    }
    
    @IBAction func addPagesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddPages", sender: self)
    }
    
    @IBAction func bookFinishedPressed(_ sender: UIButton) {
        if let book = book {
            let ref = db.collection("books").document(book.bookID)
                    
            ref.updateData(["isFinished" : true, "pagesLeftToRead" : 0, "pagesAlreadyRead" : book.totalPages, "dateOfEndReading" : Date()])
        }
    }
}
