//
//  GoogleBooksDatas.swift
//  ReadToday
//
//  Created by Mickael Lokhate on 14/01/2021.
//

import UIKit

struct GoogleBooksDatas: Codable {
    let items: [Items]
}

struct Items: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let imageLinks: ImagesLinks?
}

struct ImagesLinks: Codable {
    let thumbnail: String
}
