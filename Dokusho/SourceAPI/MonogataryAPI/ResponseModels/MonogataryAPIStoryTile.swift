//
//  MonogataryAPIStoryTile.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/25/23.
//

import Foundation
public class MonogataryAPIStoryTile: Codable {
    let backgroundImage: String
    let comments: String?
    let feelingType: String?
    let feelings: String?
    let firstEpisode: String?
    let firstEpisodeId: String?
    let genre: String?
    let isFinished: Bool?
    let nickname: String?
    let readingTime: String?
    let recommendReason: String?
    let storyId: String
    let storyTitle: String
    let theme: String?
    let themeId: String?
    let transparentImage: String?
    let userID: String?
}
