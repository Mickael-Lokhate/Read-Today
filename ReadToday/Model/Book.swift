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
    let description: String
    let publisher: String
    let publishedDate: String
    let imageLink: String
    let pagesAlreadyRead: Int
    var readingFrequency: String
    var pagesToReadByFrequency: Int
    var dateOfEndReading: Date
    var pagesLeftToRead: Int {
        return totalPages - pagesAlreadyRead
    }
    var bookID: String
    var isFinished: Bool = false
    
    mutating func setPagesToRead(for date: Date, with frequency: String = "Tous les jours"){
        let daysNbr = Int(ceil(Date().distance(to: date) / 86400))
        let weekNbr = Int(ceil(Double(daysNbr) / 7.0))
        let monthNbr = Int(ceil(Double(weekNbr) / 4.0))
        switch frequency {
        case "Tous les jours":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(daysNbr)))
        case "1 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)))
        case "2 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)) / 2)
        case "3 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)) / 3)
        case "4 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)) / 4)
        case "5 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)) / 5)
        case "6 fois/semaines":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(weekNbr)) / 6)
        case "1 fois/mois":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(monthNbr)))
        case "2 fois/mois":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(monthNbr)) / 2)
        case "3 fois/mois":
            self.pagesToReadByFrequency = Int(ceil(Double(totalPages) / Double(monthNbr)) / 3)
        default:
            self.pagesToReadByFrequency = 5
        }
    }
    
    mutating func setDate(for stringFrequency: String, and pages: Int = 5){
        let frequency = totalPages / pages
        switch stringFrequency {
        case "Tous les jours":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * 86400))
        case "1 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * (7 * 86400)))
        case "2 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * Int(ceil(3.5 * 86400.0))))
        case "3 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * Int(ceil(Double(7/3) * 86400.0))))
        case "4 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * Int(ceil(1.75 * 86400.0))))
        case "5 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * Int(ceil(1.4 * 86400))))
        case "6 fois/semaines":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(frequency * Int(ceil(Double(7/6) * 86400))))
        case "1 fois/mois":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval((28 * 86400) * frequency))
        case "2 fois/mois":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval((14 * 86400) * frequency))
        case "3 fois/mois":
            self.dateOfEndReading = Date(timeIntervalSinceNow: TimeInterval(Int(ceil(Double(28/3) * 86400)) * frequency))
        default:
            self.dateOfEndReading = Date()
        }
    }
}
