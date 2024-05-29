//
//  BooksMetadata.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct BooksMetadata: Codable {
    let authors: [Author]
    let tags: [String]
    let releaseDate: String?
    let summary: String
    let summaryNumber: String
    let created: String
    let lastModified: String
}
