//
//  KomgaResponseTypesV2.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/15/23.
//

import Foundation

class KomgaChaptersResultsV2: Codable {
    let content: [KomgaMangaVolume]
}

class KomgaMangaVolume: Codable {
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
    let media: KomgaChapterMediaV2
    let metadata: KomgaChapterMetadataV2
    let readProgress: KomgaReadProgress?
    let deleted: Bool
    let fileHash: String
}

class KomgaReadProgress: Codable {
    let page: Int
    let completed: Bool?
    let readDate: String?
    let created: String?
    let lastModified: String?
}
class KomgaChapterMediaV2: Codable {
    let status: String
    let mediaType: String
    let pagesCount: Int
    let comment: String
}

class KomgaChapterMetadataV2: Codable {
    let title: String
    let titleLock: Bool
    let summary: String
    let summaryLock: Bool
    let number: String
    let numberLock: Bool
    let numberSort: Int
    let numberSortLock: Bool
    let releaseDate: String?
    let releaseDateLock: Bool
    let authors: [String]
    let authorsLock: Bool
    let tags: [String]
    let tagsLock: Bool
    let isbn: String
    let isbnLock: Bool
    let links: [String]
    let linksLock: Bool
    let created: String
    let lastModified: String
}
