//
//  SearchViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 13/01/2021.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController {
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var books: [Book] = []
    var userID: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        
        userID = defaults.string(forKey: "userID")
        guard userID != nil else {
            performSegue(withIdentifier: "unwindFromSearch", sender: self)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchDetails" {
            let destinationVC = segue.destination as! AddBookViewController
            
            if let indexPath = searchTableView.indexPathForSelectedRow {
                destinationVC.selectedBook = books[indexPath.row]
            }
        }
    }
    
    internal func getDataFromGoogleAPI(for searchQuery: String) {
        let apiKey = "AIzaSyAnr3sKnQFS6yohB28wITQ0j3o7XAN_npE"
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(searchQuery)&key=\(apiKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let data = data {
                    var result: GoogleBooksDatas?
                    do {
                        result = try JSONDecoder().decode(GoogleBooksDatas.self, from: data)
                    } catch {
                        print("Error while decoding datas : \(error)")
                    }
                    if let json = result {
                        self.addBooksToArray(with: json)
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    }
                } else {
                    print("Error when getting datas")
                }
            }
            task.resume()
        } else {
            print("Error with the URL")
        }
    }
    
    private func addBooksToArray(with data: GoogleBooksDatas) {
        let searchResult = data.items
        
        for book in searchResult {
            let infos = book.volumeInfo
            let title = infos.title
            if let author = infos.authors {
                if let totalPages = infos.pageCount {
                    if let description = infos.description {
                        if let publisher = infos.publisher {
                            if let publishedDate = infos.publishedDate {
                                if let imageLink = infos.imageLinks {
                                    let image = imageLink.thumbnail
                                    let bookData = [title, author[0], String(totalPages), description, publisher, publishedDate, image, book.id]
                                    createABook(with: bookData)
                                }
                            }
                        }
                    }
                }
            } else {
                
            }
        }
    }
    
    private func createABook(with bookData: [String]) {
        let book = Book(title: bookData[0],
                        author: bookData[1],
                        totalPages: Int(bookData[2])!,
                        description: bookData[3],
                        publisher: bookData[4],
                        publishedDate: bookData[5],
                        imageLink: bookData[6],
                        pagesAlreadyRead: 0,
                        readingFrequency: "Tous les jours",
                        pagesToReadByFrequency: 5,
                        dateOfEndReading: Date(),
                        bookID: bookData[7],
                        isNotificationActive: true,
                        notificationTime: Date())
        books.append(book)
    }
}

//MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
}

//MARK: - TableView Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchResultTableViewCell
        let book = books[indexPath.row]
        if let url = URL(string: book.imageLink) {
            cell.searchResultImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "noImage"))
        }
        
        cell.searchResultTitleLabel.text = book.title
        cell.searchResultAuthorLabel.text = "de \(book.author)"
        cell.searchResultPagesLabel.text = "Il y a \(book.totalPages) pages"
        cell.searchResultPublishLabel.text = "Publié le \(book.publishedDate) par \(book.publisher)"
        
        cell.searchResultView.backgroundColor = UIColor(named: "Purples")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSearchDetails", sender: self)
    }
}

//MARK: - SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var request = searchBar.text {
            if request != " " {
                request = request.replacingOccurrences(of: " ", with: "+")
                books = []
                self.getDataFromGoogleAPI(for: request)
            }
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
