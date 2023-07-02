//
//  MonogataryChapterDetails.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/26/23.
//

import Foundation

public class MonogataryEpisodeContents: Codable {
    let allEpisodeNumber: Int?
    let backgroundImage: String
    let comments: String?
    let coverImage: String?
    let createdAt: String?
    let currentEpisodeNumber: Int?
    let episode: String
    let episodeId: String
    let episodeTitle: String
    let genre: String?
    let nextEpisodeId: String?
    let overFifteen: Bool?
    let parentComments: Int?
    let previousEpisodeId: String?
    let profileImage: String?
    let storyId: String
    let storyTitle: String?
    let theme: String?
    let themeId: String?
    let transparentImage: String?
    let userId: String?
    let userName: String?
    
}
public class MonogataryRelatedImages: Codable {
    let image: String?
}
public class MonogataryChapterDetails: Codable {
    let episodeContents: MonogataryEpisodeContents
    let modifiedHistory: [MonogataryModifiedHistories]?
    let relatedImages: [MonogataryRelatedImages]?
}
