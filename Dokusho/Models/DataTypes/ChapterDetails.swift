//
//  ChapterDetails.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/10/23.
//

import Foundation

struct ChapterDetails: Codable, Hashable {
    let chapterId: String
    var pages: [ChapterPage]
    var text: String? = ""
}

struct ChapterPage: Codable, Hashable {
    let link: String
    let page: String
}
