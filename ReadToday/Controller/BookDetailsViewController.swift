//
//  BookDetailsViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 11/01/2021.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var haveReadLabel: UILabel!
    @IBOutlet weak var toReadLabel: UILabel!
    @IBOutlet weak var endOfReadingLabel: UILabel!
    
    var selectedBook: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
