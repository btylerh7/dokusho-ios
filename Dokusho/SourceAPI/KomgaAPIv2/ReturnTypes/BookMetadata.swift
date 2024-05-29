//
//  BookMetadata.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct BookMetadata: Codable {
    let title: String
    let titleLock: Bool?
    let summary: String
    let summaryLock: Bool?
    let number: String
    let numberLock: Bool?
    let numberSort: Int?
    let numberSortLock: Bool?
    let releaseDate: String?
    let releaseDateLock: Bool?
    let authors: [Author]
    let authorsLock: Bool?
    let tags: [String]?
    let tagsLock: Bool?
    let isbn: String?
    let isbnLock: Bool?
    let links: [BookLink]?
    let linksLock: Bool?
    let created: String?
    let lastModified: String?
}

struct BookLink: Codable {
    let label: String
    let url: String
}
