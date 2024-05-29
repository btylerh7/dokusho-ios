//
//  CategoryContainer.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/28/24.
//

import Foundation
import SwiftData

actor CategoryContainer {
    @MainActor 
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([CategoryItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            container.mainContext.insert(CategoryItem(categoryId: "All",title: "All", libraryItems: []))
            shouldCreateDefaults = false
        }
        return container
    }
}
