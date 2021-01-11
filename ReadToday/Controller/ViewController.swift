//
//  ViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 06/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var booksTableView: UITableView!
    
    var books = ["Lève-toi et code", "The Hunger Games", "Harry Potter"]
    var authors = ["Rabbin des bois", "Suzanne Collins", "J.K. Rowling"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        booksTableView.delegate = self
        booksTableView.dataSource = self
        
        //Table view design
        booksTableView.separatorStyle = .none
        booksTableView.showsVerticalScrollIndicator = false
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
        let bookTitle = books[indexPath.row]
        
        cell.bookTitleLabel.text = bookTitle
        cell.bookAuthorLabel.text = "de \(authors[indexPath.row])"
        cell.bookImageView.image = UIImage(named: bookTitle)
        cell.bookPagesLabel.text = "114/114 pages"
        
        if indexPath.row % 2 == 0 {
            cell.bookView.backgroundColor = UIColor(named: "DarkPurple")
        } else {
            cell.bookView.backgroundColor = UIColor(named: "LightPurple")
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}

