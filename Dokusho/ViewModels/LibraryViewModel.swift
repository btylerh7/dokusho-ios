//
//  LibraryViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/6/23.
//

import Foundation

@MainActor
final public class LibraryViewModel {
    
    init() {
        fetchCategoryList()
    }
    
    var categories: [String] = ["All"]
    var categoriesObservable: ObservableItem<[String]> = ObservableItem([])
    
    func fetchCategoryList() {
        let request = CategoryObject.all()
        if let results = try? CoreDataManager.shared.viewContext.fetch(request) {
            for category in results {
                self.categories.append(category.categoryId ?? "")
                self.categoriesObservable.value.append(category.categoryId ?? "")
                print(self.categories)
            }
        }
    }
    func handleRefresh() {
        print("refreshing")
        self.categories = ["All"]
        self.categoriesObservable.value = []
        self.fetchCategoryList()
        print("refreshed")
    }
}
