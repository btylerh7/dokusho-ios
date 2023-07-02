//
//  MonogataryStoryDetails.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/25/23.
//

import Foundation

public class MonogataryEpisode: Codable {
    let backgroundImage: String
    let episodeId: String
    let episodeTitle: String
    let publishAt: String?
    let transparentImage: String?
}

public class MonogataryModifiedHistories: Codable {
    let modifiedContents: String?
    let modifiedHistoryId: Int?
    
}

public class MonogataryThumbnails: Codable {
    let image: String?
    let imageId: String?
}

public class MonogataryStoryDetails: Codable {
    let backgroundImage: String
    let bookmarkedEpisodeId: String?
    let commentsCount: Int?
    let episodes: [MonogataryEpisode]
    let episodesCount: Int?
    let favoritesCount: Int?
    let feelingsCount: Int?
    let firstEpisode: String?
    let firstEpisodeId: String?
    let genre: String?
    let isFinished: Bool?
    let isFollorwing: Bool?
    let isMonoChan: Bool?
    let lastEpisodeId: String?
    let modifiedHistories: [MonogataryModifiedHistories]?
    let nickname: String?
    let overFifteen: Bool?
    let profileImage: String?
    let publishAt: String?
    let readingTime: String?
    let storyId: String
    let storySummary: String
    let storyTitle: String
    let storyUpdatedAt: String?
    let theme: String?
    let themeId: String?
    let thumbnails: [MonogataryThumbnails]?
    let thumbnailsCount: Int?
    let transparentImage: String?
    let userId: String?
}
