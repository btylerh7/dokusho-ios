//
//  KomgaResponseTypes.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/14/23.
//

import Foundation

// MARK: Homepage Results

public class KomgaHomepageResults: Codable {
    let content: [KomgaMangaDetailsResult]
}

// MARK: Manga Details
public class KomgaMangaDetailsResult: Codable {
    let id: String
    let libraryId: String
    let name: String
    let url: String?
    let created: String?
    let lastModified: String?
    let fileLastModified: String?
    let booksCount: Int?
    let booksReadCount: Int?
    let booksUnreadCount: Int?
    let booksInProgressCount: Int?
    let metadata: KomgaMetadata
    let booksMetadata: KomgaBooksMetadata
    let deleted: Bool?
}

public class KomgaMetadata: Codable {
    let status: String?
    let statusLock: Bool?
    let title: String
    let titleLock: Bool?
    let titleSort: String?
    let titleSortLock: Bool?
    let summary: String
    let summaryLock: Bool?
    let readingDirection: String?
    let readingDirectionLock: Bool?
    let publisher: String?
    let publisherLock: Bool?
    let ageRating: String?
    let ageRatingLock: Bool?
    let language: String?
    let languageLock: Bool?
    let genres: [String]
    let genresLock: Bool?
    let tags: [String]
    let tagsLock: Bool?
    let totalBookCount: Int?
    let totalBookCountLock: Bool?
    let sharingLabels: [String]
    let sharingLabelsLock: Bool?
    let links: [String]
    let linksLock: Bool?
    let alternateTitles: [String]
    let alternateTitlesLock: Bool?
    let created: String?
    let lastModified: String?
}

public class KomgaBooksMetadata: Codable {
    let authors: [KomgaAuthors]
    let tags: [String]
    let releaseDate: String?
    let summary: String?
    let summaryNumber: String?
    let created: String?
    let lastModified: String?
}

// MARK: Chapter(Volume) Information
public class KomgaChaptersResults: Codable {
    let content: [KomgaChapter]
}

public class KomgaChapter: Codable {
    let id: String
    let seriesId: String
    let seriesTitle: String
    let libraryId: String
    let name: String
    let url: String
    let number: Int?
    let created: String?
    let lastModified: String?
    let fileLastModified: String?
    let sizeBytes: Int?
    let size: String
    let media: KomgaChapterMedia
    let metadata: KomgaChapterMetadata
    let readProgress: String?
    let deleted: Bool?
    let fileHash: String?
}

public class KomgaChapterMedia: Codable {
    let status: String?
    let mediaType: String?
    let pagesCount: Int?
    let comment: String?
}

public class KomgaChapterMetadata: Codable {
    let title: String
    let titleLock: Bool?
    let summary: String?
    let summaryLock: Bool?
    let number: Int?
    let numberLock: Bool?
    let numberSort: Int?
    let numberSortLock: Bool?
    let releaseDate: String?
    let releaseDateLock: Bool?
    let authors: [String]
    let authorsLock: Bool?
    let tags: [String]
    let tagsLock: Bool?
    let isbn: String?
    let isbnLock: Bool?
    let links: [String]
    let linksLock: Bool?
    let created: String?
    let lastModified: String?
}


// MARK: Chapter Details

public class KomgaPagesResults: Codable {
    let results: [KomgaBookPage]
}

public class KomgaBookPage: Codable {
    let number: Int
    let fileName: String
    let mediaType: String?
    let width: Int?
    let height: Int?
    let sizeBytes: Int?
    let size: String?
}

public class KomgaAuthors: Codable {
    let name: String
    let role: String
}

