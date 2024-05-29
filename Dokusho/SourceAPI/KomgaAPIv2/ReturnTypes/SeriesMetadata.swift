//
//  SeriesMetadata.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct SeriesMetadata: Codable {
    let status: String
    let statusLock: Bool
    let title: String
    let titleLock: Bool
    let titleSort: String
    let titleSortLock: Bool
    let summary: String
    let summaryLock: Bool
    let readingDirection: String
    let readingDirectionLock: Bool
    let publisher: String
    let publisherLock: Bool
    let ageRating: String?
    let ageRatingLock: Bool
    let language: String
    let languageLock: Bool
    let genres: [String]
    let genresLock: Bool
    let tags: [String]
    let tagsLock: Bool
    let totalBookCount: Int?
    let totalBookCountLock: Bool
    let sharingLabels: [String]
    let sharingLabelsLock: Bool
    let links: [String]
    let linksLock: Bool
    let alternateTitles: [String]
    let alternateTitlesLock: Bool
    let created: String
    let lastModified: String
}


