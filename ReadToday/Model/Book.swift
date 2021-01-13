//
//  Book.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 12/01/2021.
//

import UIKit

internal struct Book {
    let title: String
    let author: String
    let totalPages: Int
    let pagesAlreadyRead: Int
    let readingFrequency: String
    let pagesToReadByFrequency: Int
    let dateOfEndReading: Date
    var pagesLeftToRead: Int {
        return totalPages - pagesAlreadyRead
    }
}
