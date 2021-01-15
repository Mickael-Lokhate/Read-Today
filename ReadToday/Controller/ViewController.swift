//
//  ViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 06/01/2021.
//

import UIKit
import FirebaseFirestore
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet var booksTableView: UITableView!
    
    internal var books: [Book] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        booksTableView.dataSource = self
        booksTableView.delegate = self
        
        //Table view design
        booksTableView.separatorStyle = .none
        booksTableView.showsVerticalScrollIndicator = false
        
        getDataFromFirestore(with: db)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            let destinationVC = segue.destination as! BookDetailsViewController
            
            if let indexPath = booksTableView.indexPathForSelectedRow {
                destinationVC.selectedBook = books[indexPath.row]
            }
        }
    }
    
    private func getDataFromFirestore(with db: Firestore) {
        db.collection("books").order(by: "pagesAlreadyRead", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.addBookToArray(document.data())
                    DispatchQueue.main.async {
                        self.booksTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func addBookToArray(_ data: [String: Any]) {
        
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
 
        
        let book = Book(title: title,
                        author: author,
                        totalPages: totalPages,
                        description: description,
                        publisher: publisher,
                        publishedDate: publishedDate,
                        imageLink: imageLink,
                        pagesAlreadyRead: pagesAlreadyRead,
                        readingFrequency: readingFrequency,
                        pagesToReadByFrequency: pagesPerFrequency,
                        dateOfEndReading: dateOfEndReading)
        books.append(book)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
        let book = books[indexPath.row]
        
        if let url = URL(string: book.imageLink) {
            cell.bookImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
        }
        
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorLabel.text = "de \(book.author)"
        cell.bookPagesLabel.text = "\(book.pagesAlreadyRead)/\(book.totalPages) pages"
        
        if indexPath.row % 2 == 0 {
            cell.bookView.backgroundColor = UIColor(named: "DarkPurple")
        } else {
            cell.bookView.backgroundColor = UIColor(named: "LightPurple")
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToDetails", sender: self)
    }
}

