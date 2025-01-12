//
//  MangaDetails.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/1/23.
//

import Foundation

public struct MangaDetails: Codable, Equatable {
    let sourceId: String
    let mangaId: String
    let title: String
    let image: String
    let description: String
    let author: String
}
