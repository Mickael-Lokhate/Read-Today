//
//  AddPagesController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 20/01/2021.
//

import UIKit
import FirebaseFirestore

class AddPagesController: UIViewController {
    
    @IBOutlet weak var pagesPickerView: UIPickerView!
    
    var selectedBook: Book?
    private let db = Firestore.firestore()
    private var pagesRead = 0
    private var datasPickerView: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagesPickerView.delegate = self
        pagesPickerView.dataSource = self
        
        if let book = selectedBook {
            pagesRead = book.pagesAlreadyRead
            for i in 1...book.pagesLeftToRead {
                datasPickerView.append(i)
            }

            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPages(_ sender: UIButton) {
        if let book = selectedBook {
            let ref = db.collection("books").document(book.bookID)
            let selectedNbr = (pagesPickerView.selectedRow(inComponent: 0)) + 1
            
            ref.getDocument { (doc, error) in
                if let error = error {
                    print("Error getting datas : \(error)")
                } else {
                    if let doc = doc {
                        if let datas = doc.data(){
                            self.pagesRead = datas["pagesAlreadyRead"] as! Int
                        }
                    }
                }
            }
            pagesRead += Int(selectedNbr)
            
            ref.updateData(["pagesAlreadyRead" : pagesRead])
            dismiss(animated: true, completion: nil)
        } else {
            print("Erreur")
            dismiss(animated: true, completion: nil)
        }
        
    }
}

extension AddPagesController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(datasPickerView[row])
    }
    
    
}
