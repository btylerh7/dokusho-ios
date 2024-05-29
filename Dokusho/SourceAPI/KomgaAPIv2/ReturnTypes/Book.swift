//
//  Book.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct Book: Codable, Hashable, Identifiable {
    let id: String
    let seriesId: String
    let seriesTitle: String
    let libraryId: String
    let name: String
    let url: String
    let number: Int
    let created: String
    let lastModified: String
    let fileLastModified: String
    let sizeBytes: Int
    let size: String
    let media: Media
    let metadata: BookMetadata
    let readProgress: ReadProgress?
    let deleted: Bool
    let fileHash: String
    
    static func == (lhs: Book, rhs: Book) -> Bool {
            return lhs.id == rhs.id
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// This is NOT a komga return type. This is to help with left to right reading
struct BookPage: Codable, Hashable {
    let page: Int
    let url: String
}
