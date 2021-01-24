//
//  AddBookViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 12/01/2021.
//

import UIKit
import FirebaseFirestore
import AlamofireImage

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    @IBOutlet weak var pagesPerFrequencyTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    
    let db = Firestore.firestore()
    private let dataReadingFrequency: [String] = ["Tous les jours", "1 fois/semaines", "2 fois/semaines", "3 fois/semaines", "4 fois/semaines", "5 fois/semaines", "6 fois/semaines", "1 fois/mois", "2 fois/mois", "3 fois/mois"]
    var selectedBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self
        
        if var book = selectedBook {
            book.setDate(for: book.readingFrequency)
            showBookDetails(of: book)
            pagesPerFrequencyTextField.addTarget(self, action: #selector(pagesPerFrequencyChanged), for: .editingDidEndOnExit)
            datePickerView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func dateChanged(){
        if var book = selectedBook {
            book.setPagesToRead(for: datePickerView.date, with: book.readingFrequency)
            pagesPerFrequencyTextField.text = String(book.pagesToReadByFrequency)
            selectedBook?.dateOfEndReading  = datePickerView.date
        }
    }
    
    @objc private func pagesPerFrequencyChanged(){
        if var book = selectedBook {
            if let pages = pagesPerFrequencyTextField.text {
                if let pages = Int(pages) {
                    if pages <= book.totalPages {
                        book.setDate(for: book.readingFrequency, and: pages)
                        datePickerView.date = book.dateOfEndReading
                        selectedBook?.pagesToReadByFrequency = pages
                        pagesPerFrequencyTextField.backgroundColor = .systemBackground
                    } else {
                        pagesPerFrequencyTextField.backgroundColor = .red
                    }
                }
            }
        }
    }
    
    private func showBookDetails(of book: Book) {
        titleLabel.text = book.title
        authorLabel.text = "de \(book.author)"
        descriptionLabel.text = book.description
        if let url = URL(string: book.imageLink) {
            imageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
        }
        pagesLabel.text = "Avec \(book.totalPages) pages"
        datePickerView.date = book.dateOfEndReading
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let pagesToRead = selectedBook?.pagesToReadByFrequency ?? 5
        let frequency = dataReadingFrequency[frequencyPickerView.selectedRow(inComponent: 0)]
        let date = datePickerView.date
        
        if let book = selectedBook {
            let newBook = Book(title: book.title,
                               author: book.author,
                               totalPages: book.totalPages,
                               description: book.description,
                               publisher: book.publisher,
                               publishedDate: book.publishedDate,
                               imageLink: book.imageLink,
                               pagesAlreadyRead: 0,
                               readingFrequency: frequency,
                               pagesToReadByFrequency: pagesToRead,
                               dateOfEndReading: date,
                               bookID: book.bookID)
            
            addToDatabase(newBook, with: db)
        }
        
    }
}

//MARK: - Extension PickerView delegate & data source
extension AddBookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataReadingFrequency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataReadingFrequency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if var book = selectedBook{
            selectedBook?.readingFrequency = dataReadingFrequency[row]
            if let pages = pagesPerFrequencyTextField.text {
                if let pages = Int(pages) {
                    book.setDate(for: dataReadingFrequency[row], and: pages)
                    datePickerView.date = book.dateOfEndReading
                } else {
                    book.setDate(for: dataReadingFrequency[row])
                    datePickerView.date = book.dateOfEndReading
                }
            }
        }
    }
}

func addToDatabase(_ newBook: Book, with db: Firestore) {
    db.collection("books").addDocument(data: [
        "title": newBook.title,
        "author": newBook.author,
        "totalPage": newBook.totalPages,
        "description": newBook.description,
        "publisher": newBook.publisher,
        "publishedDate": newBook.publishedDate,
        "imageLink": newBook.imageLink,
        "pagesAlreadyRead": newBook.pagesAlreadyRead,
        "readingFrequency": newBook.readingFrequency,
        "pagesPerFrequency": newBook.pagesToReadByFrequency,
        "dateOfEndReading": newBook.dateOfEndReading,
        "userId": "Ab1c2B"
    ])
}
