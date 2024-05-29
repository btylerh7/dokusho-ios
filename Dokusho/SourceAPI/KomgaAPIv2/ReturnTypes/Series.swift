//
//  Series.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct Series: Codable, Hashable {

    let id: String
    let libraryId: String
    let name: String
    let url: String
    let created: String
    let lastModified: String
    let fileLastModified: String
    let booksCount: Int
    let booksReadCount: Int
    let booksUnreadCount: Int
    let booksInProgressCount: Int
    let metadata: SeriesMetadata
    let booksMetadata: BooksMetadata
    let deleted: Bool
    
    static func == (lhs: Series, rhs: Series) -> Bool {
            return lhs.id == rhs.id
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



