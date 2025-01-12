//
//  ChapterDetails.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/10/23.
//

import Foundation

public struct ChapterDetails: Codable, Hashable {
    let chapterId: String
    var pages: [ChapterPage]
    var text: String? = ""
}

public struct ChapterPage: Codable, Hashable {
    let link: String
    let page: String
}
