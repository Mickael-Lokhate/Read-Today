//
//  BookDetailsViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 11/01/2021.
//

import UIKit
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
    
    var selectedBook: Book?
    var bookID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = selectedBook {
            if let url = URL(string: book.imageLink) {
                bookImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
            }
            
            titleLabel.text = book.title
            descriptionLabel.text = book.description
            toReadLabel.text = "Il vous reste \(book.pagesLeftToRead) pages à lire."
            totalPagesLabel.text = "Il y a \(book.totalPages) pages."
            let dateFormat = DateFormatter()
            dateFormat.timeStyle = .none
            dateFormat.dateStyle = .medium
            if let local = Locale.current.languageCode {
                dateFormat.locale = Locale(identifier: local)
                dateLabel.text = "Terminé avant : \(dateFormat.string(from: book.dateOfEndReading))"
            } else {
                dateLabel.text = "Terminé avant : \(book.dateOfEndReading.description)"
            }
            
            frequencyLabel.text = "Fréquence de lecture : \(book.readingFrequency)"
            pagesPerFrequencyLabel.text = "Pages à lire : \(book.pagesToReadByFrequency)"
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddPages" {
            let destinationVC = segue.destination as! AddPagesController
            destinationVC.bookID = bookID
            destinationVC.selectedBook = selectedBook
        }
    }
    //RELOAD DATA DEPUIS FIRESTORE POUR METTRE A JOUR PAGES APRES AJOUT
    
    @IBAction func addPagesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddPages", sender: self)
    }
}
