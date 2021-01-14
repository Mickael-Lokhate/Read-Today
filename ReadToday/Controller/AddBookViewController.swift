//
//  AddBookViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 12/01/2021.
//

import UIKit
import FirebaseFirestore

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var numberOfPagesTextField: UITextField!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    @IBOutlet weak var pagesPerFrequencyTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    let db = Firestore.firestore()
    private let dataReadingFrequency: [String] = ["Tous les jours", "1 fois/semaines", "2 fois/semaines", "3 fois/semaines", "4 fois/semaines", "5 fois/semaines", "6 fois/semaines", "1 fois/mois", "2 fois/mois", "3 fois/mois", "Chaques semaines"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Annuler l'ajout", message: "Êtes-vous sûr de vouloir annuler l'ajout d'un livre ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let title = titleTextField.text {
            if let author = authorTextField.text {
                if let totalPages = numberOfPagesTextField.text {
                    if let pagesPerFrequency = pagesPerFrequencyTextField.text {
                        if !title.isEmpty {
                            if !author.isEmpty {
                                if !totalPages.isEmpty {
                                    if !pagesPerFrequency.isEmpty {
                                        if Int(pagesPerFrequency)! > 0 && Int(pagesPerFrequency)! <= Int(totalPages)!{
                                            let rowFrequency = frequencyPickerView.selectedRow(inComponent: 0)
                                            let newBook = Book(title: title,
                                                               author: author,
                                                               totalPages: Int(totalPages)!,
                                                               description: "temp desc",
                                                               publisher: "temp publi",
                                                               publishedDate: "temp date",
                                                               imageLink: "link temp",
                                                               pagesAlreadyRead: 0,
                                                               readingFrequency: dataReadingFrequency[rowFrequency],
                                                               pagesToReadByFrequency: Int(pagesPerFrequency)!,
                                                               dateOfEndReading: datePickerView.date)
                                            addToDatabase(newBook, with: db)
                                            
                                            navigationController?.popViewController(animated: true)
                                        } else {
                                            pagesPerFrequencyTextField.backgroundColor = .systemRed
                                        }
                                    } else {
                                        pagesPerFrequencyTextField.backgroundColor = .systemRed
                                    }
                                } else {
                                    numberOfPagesTextField.backgroundColor = .systemRed
                                }
                            } else {
                                authorTextField.backgroundColor = .systemRed
                            }
                        } else {
                            titleTextField.backgroundColor = .systemRed
                        }
                    } else {
                        pagesPerFrequencyTextField.backgroundColor = .systemRed
                    }
                } else {
                    numberOfPagesTextField.backgroundColor = .systemRed
                }
            } else {
                authorTextField.backgroundColor = .systemRed
            }
        } else {
            titleTextField.backgroundColor = .systemRed
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
}

func addToDatabase(_ newBook: Book, with db: Firestore) {
    db.collection("books").addDocument(data: [
        "title": newBook.title,
        "author": newBook.author,
        "totalPage": newBook.totalPages,
        "pagesAlreadyRead": newBook.pagesAlreadyRead,
        "readingFrequency": newBook.readingFrequency,
        "pagesPerFrequency": newBook.pagesToReadByFrequency,
        "dateOfEndReading": newBook.dateOfEndReading,
        "userId": "Ab1c2B"
    ])
}
