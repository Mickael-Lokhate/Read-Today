//
//  ViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 06/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var booksTableView: UITableView!
    
    private var leveToiEtCode = Book(title: "Lève-toi et code", author: "Rabbin des bois", totalPages: 114, pagesAlreadyRead: 114, readingFrequency: "tous les jours", pagesToReadByFrequency: 5, dateOfEndReading: Date(timeIntervalSince1970: 5689))
    private var hungerGames = Book(title: "The Hunger Games", author: "Rabbin des bois", totalPages: 167, pagesAlreadyRead: 103, readingFrequency: "une fois par mois", pagesToReadByFrequency: 20, dateOfEndReading: Date(timeIntervalSince1970: 645098))
    private var harryPotter = Book(title: "Harry Potter", author: "J.K. Rowling", totalPages: 221, pagesAlreadyRead: 34, readingFrequency: "tous les jours", pagesToReadByFrequency: 14, dateOfEndReading: Date(timeIntervalSince1970: 56919))
    
    private var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        booksTableView.dataSource = self
        booksTableView.delegate = self
        
        //Table view design
        booksTableView.separatorStyle = .none
        booksTableView.showsVerticalScrollIndicator = false
        
        books = [leveToiEtCode, hungerGames, harryPotter]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            let destinationVC = segue.destination as! BookDetailsViewController
            
            if let indexPath = booksTableView.indexPathForSelectedRow {
                destinationVC.selectedBook = books[indexPath.row]
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
        let book = books[indexPath.row]
        
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorLabel.text = "de \(book.author)"
        cell.bookImageView.image = UIImage(named: book.title)
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
