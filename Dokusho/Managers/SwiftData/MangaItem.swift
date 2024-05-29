//
//  MangaItem.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/27/24.
//

import Foundation
import SwiftData

@Model
final class MangaItem {
    var id: String
    var chapterCount: Int
    var desc: String?
    var author: String?
    var image: String?
    var sourceId: String
    var title: String
    var url: String
    
    var chapters: [ChapterItem]
    var history: [HistoryItem]
    var libraryItem: LibraryItem?
    
    init(id: String, chapterCount: Int, desc: String? = nil, author: String? = nil, image: String? = nil, sourceId: String, title: String, url: String, chapters: [ChapterItem] = [], history: [HistoryItem] = [], libraryItem: LibraryItem? = nil) {
        self.id = id
        self.chapterCount = chapterCount
        self.desc = desc
        self.author = author
        self.image = image
        self.sourceId = sourceId
        self.title = title
        self.url = url
        self.chapters = chapters
        self.history = history
        self.libraryItem = libraryItem
    }
}
