//
//  HistoryItem.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/27/24.
//

import Foundation
import SwiftData

@Model
final class HistoryItem {
    var chapterId: String
    var completed: Bool
    var mangaId: String
    var progress: Int
    var sourceId: String
    var total: Int
    
    var chapter: ChapterItem?
    var manga: MangaItem?
    
    init(chapterId: String, completed: Bool, mangaId: String, progress: Int, sourceId: String, total: Int) {
        self.chapterId = chapterId
        self.completed = completed
        self.mangaId = mangaId
        self.progress = progress
        self.sourceId = sourceId
        self.total = total
    }
}
