//
//  ChapterItem.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/27/24.
//

import Foundation
import SwiftData

@Model
final class ChapterItem {
    var chapter: Float
    var id: String
    var lang: String
    var mangaId: String
    var sourceId: String
    var title: String
    var url: String
    
    var history: HistoryItem?
    var manga: MangaItem?
    
    init(chapter: Float, id: String, lang: String, mangaId: String, sourceId: String, title: String, url: String, history: HistoryItem? = nil, manga: MangaItem? = nil) {
        self.chapter = chapter
        self.id = id
        self.lang = lang
        self.mangaId = mangaId
        self.sourceId = sourceId
        self.title = title
        self.url = url
        self.history = history
        self.manga = manga
    }
    

}
