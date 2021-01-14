//
//  SearchViewController.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 13/01/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
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
            let title = book.volumeInfo.title
            if let author = book.volumeInfo.authors {
                if let pagesTotal = book.volumeInfo.pageCount {
                    let newBook = Book(title: title,
                                       author: author[0],
                                       totalPages: pagesTotal,
                                       pagesAlreadyRead: 0,
                                       readingFrequency: "Tous les jours",
                                       pagesToReadByFrequency: 1,
                                       dateOfEndReading: Date())
                    books.append(newBook)
                }
            } else {
                if let pagesTotal = book.volumeInfo.pageCount {
                    let newBook = Book(title: title,
                                       author: "Inconnu",
                                       totalPages: pagesTotal,
                                       pagesAlreadyRead: 0,
                                       readingFrequency: "Tous les jours",
                                       pagesToReadByFrequency: 1,
                                       dateOfEndReading: Date())
                    books.append(newBook)
                } else {
                    let newBook = Book(title: title,
                                       author: "Inconnu",
                                       totalPages: 1,
                                       pagesAlreadyRead: 0,
                                       readingFrequency: "Tous les jours",
                                       pagesToReadByFrequency: 1,
                                       dateOfEndReading: Date())
                    books.append(newBook)
                }
            }
            
        }
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
        
        cell.searchResultTitleLabel.text = book.title
        cell.searchResultAuthorLabel.text = "de \(book.author)"
        cell.searchResultPagesLabel.text = "Il y a \(book.totalPages) pages"
        cell.searchResultPublishLabel.text = "Publié le TEMP par TEMP"
        
        
        return cell
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
