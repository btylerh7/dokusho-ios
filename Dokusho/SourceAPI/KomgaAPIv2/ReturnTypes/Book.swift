//
//  Book.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation
import Observation

@Observable
public class Book: Codable, Hashable, Identifiable {
    public let id: String
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
    var readProgress: ReadProgress?
    let deleted: Bool
    let fileHash: String
    
    public static func == (lhs: Book, rhs: Book) -> Bool {
            return lhs.id == rhs.id
        }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    enum CodingKeys: String, CodingKey {
        case id
        case seriesId
        case seriesTitle
        case libraryId
        case name
        case url
        case number
        case created
        case lastModified
        case fileLastModified
        case sizeBytes
        case size
        case media
        case metadata
        case _readProgress = "readProgress"
        case deleted
        case fileHash
        case _$observationRegistrar
    }
}

// This is NOT a komga return type. This is to help with left to right reading
public struct BookPage: Codable, Hashable {
    let page: Int
    let url: String
}
