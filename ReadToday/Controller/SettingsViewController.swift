//
//  SettingsViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 27/01/2021.
//

import UIKit
import FirebaseFirestore

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var notifSwitch: UISwitch!
    @IBOutlet weak var notifTimePicker: UIDatePicker!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    @IBOutlet weak var pagesPerFrequencyTextfield: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    let db = Firestore.firestore()
    private let dataReadingFrequency: [String] = ["Tous les jours", "1 fois/semaines", "2 fois/semaines", "3 fois/semaines", "4 fois/semaines", "5 fois/semaines", "6 fois/semaines", "1 fois/mois", "2 fois/mois", "3 fois/mois"]
    var selectedBook: Book?
    var userID: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self
        pagesPerFrequencyTextfield.delegate = self
        
        userID = defaults.string(forKey: "userID")
        guard userID != nil else {
            performSegue(withIdentifier: "unwindFromSettings", sender: self)
            return
        }
        
        if let book = selectedBook {
            showDetails(of: book)
            pagesPerFrequencyTextfield.addTarget(self, action: #selector(pagesPerFrequencyChanged), for: .editingDidEndOnExit)
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
            pagesPerFrequencyTextfield.text = String(book.pagesToReadByFrequency)
            selectedBook?.dateOfEndReading  = datePickerView.date
        }
    }
    
    @objc private func pagesPerFrequencyChanged(){
        if var book = selectedBook {
            if let pages = pagesPerFrequencyTextfield.text {
                if let pages = Int(pages) {
                    if pages <= book.totalPages {
                        book.setDate(for: book.readingFrequency, and: pages)
                        datePickerView.date = book.dateOfEndReading
                        selectedBook?.pagesToReadByFrequency = pages
                        pagesPerFrequencyTextfield.backgroundColor = .systemBackground
                    } else {
                        pagesPerFrequencyTextfield.backgroundColor = .red
                    }
                }
            }
        }
    }
    
    private func showDetails(of book: Book) {
        datePickerView.date = book.dateOfEndReading
        notifTimePicker.date = book.notificationTime
        pagesPerFrequencyTextfield.text = String(book.pagesToReadByFrequency)
        var i = 0;
        for frequency in dataReadingFrequency {
            if (frequency == book.readingFrequency) {
                break
            }
            i += 1;
        }
        frequencyPickerView.selectRow(i, inComponent: 0, animated: false)
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let pagesToRead = selectedBook?.pagesToReadByFrequency ?? 5
        let frequency = dataReadingFrequency[frequencyPickerView.selectedRow(inComponent: 0)]
        let date = datePickerView.date
        let isNotificationActive = notifSwitch.isOn
        let notificationTime = notifTimePicker.date
        
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
                               bookID: book.bookID,
                               isNotificationActive: isNotificationActive,
                               notificationTime: notificationTime)
            if let userID = userID {
                updateDatabase(newBook, with: db, for: userID)
            }
        }
    }
    @IBAction func deleteBookPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Supprimer le livre", message: "Le livre et toutes les données associées seront supprimées. Êtes-vous sûr ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui, supprimer", style: .destructive, handler: { (action: UIAlertAction!) in
            if let book = self.selectedBook {
                self.db.collection("books").document(book.bookID).delete()
            }
            self.performSegue(withIdentifier: "unwindToLibraryFromSettings", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Non, annuler", style: .cancel, handler: { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Extension PickerView delegate & data source
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            if let pages = pagesPerFrequencyTextfield.text {
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

//MARK: - textfield delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private func updateDatabase(_ newBook: Book, with db: Firestore, for userID: String) {
    let bookRef = db.collection("books").document(newBook.bookID)
    
    bookRef.updateData([
                        "readingFrequency": newBook.readingFrequency,
                        "pagesPerFrequency": newBook.pagesToReadByFrequency,
                        "dateOfEndReading": newBook.dateOfEndReading,
                        "isNotificationActive": newBook.isNotificationActive,
                        "notificationTime": newBook.notificationTime]) { err in
        if let err = err {
            print("Error updating document : \(err)")
        }
        
    }
}
