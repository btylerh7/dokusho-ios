//
//  LibraryItem.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/27/24.
//

import Foundation
import SwiftData

@Model
final class LibraryItem {
    var mangaId: String
    var sourceId: String
    var image: String
    var title: String
    
    var categories: [CategoryItem]
    var manga: MangaItem
    
    init(mangaId: String, sourceId: String, image: String, title: String, categories: [CategoryItem] = [], manga: MangaItem) {
        self.mangaId = mangaId
        self.sourceId = sourceId
        self.image = image
        self.title = title
        self.categories = categories
        self.manga = manga
    }
}
