//
//  CategoryItem.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/27/24.
//

import Foundation
import SwiftData

@Model
final class CategoryItem {
    var categoryId: String
    
    @Attribute(.unique)
    var title: String
    
    var libraryItems: [LibraryItem]
    
    init(categoryId: String, title: String, libraryItems: [LibraryItem] = []) {
        self.categoryId = categoryId
        self.title = title
        self.libraryItems = libraryItems
    }
}
