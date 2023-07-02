//
//  Chapter.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/8/23.
//

import Foundation

struct Chapter: Codable, Hashable {
    let mangaId: String
    let chapterId: String
    let chapNum: Float
    let chapNumString: String
}
