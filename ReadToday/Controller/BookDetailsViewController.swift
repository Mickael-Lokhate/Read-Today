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
    @IBOutlet weak var haveReadLabel: UILabel!
    @IBOutlet weak var toReadLabel: UILabel!
    @IBOutlet weak var endOfReadingLabel: UILabel!
    @IBOutlet weak var pickerViewReadingFrequency: UIPickerView!
    @IBOutlet weak var pickerViewPagesPerFrequency: UIPickerView!
    
    var selectedBook: Book?
    private let dataReadingFrequency: [String] = ["Tous les jours", "1 fois/semaines", "2 fois/semaines", "3 fois/semaines", "4 fois/semaines", "5 fois/semaines", "6 fois/semaines", "1 fois/mois", "2 fois/mois", "3 fois/mois"]
    private var dataPagesPerFrequency: [String] = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewPagesPerFrequency.delegate = self
        pickerViewReadingFrequency.delegate = self
        pickerViewPagesPerFrequency.dataSource = self
        pickerViewReadingFrequency.dataSource = self
        
        if let book = selectedBook {
            if let url = URL(string: book.imageLink) {
                bookImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
            }
            
            navigationItem.title = book.title
            haveReadLabel.text = "Vous avez lu : \(book.pagesAlreadyRead) pages sur \(book.totalPages)."
            toReadLabel.text = "Il vous reste \(book.pagesLeftToRead) pages à lire."
            
            if book.pagesLeftToRead == 0 {
                endOfReadingLabel.text = "Vous avez fini le livre."
            } else {
                endOfReadingLabel.text = "Vous aurez fini le livre ..."
            }
            
            for i in 2...book.totalPages {
                dataPagesPerFrequency.append(String(i))
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Extension PickerView Delegate & DataSource
extension BookDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewReadingFrequency {
            return dataReadingFrequency.count
        } else {
            return dataPagesPerFrequency.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewReadingFrequency {
            return dataReadingFrequency[row]
        } else {
            return dataPagesPerFrequency[row]
        }
    }
    
}
