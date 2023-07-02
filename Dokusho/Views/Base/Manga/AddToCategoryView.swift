//
//  AddToCategoryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/19/23.
//

import SwiftUI
import CoreData

struct AddToCategoryView: View {
    @State var categories: [CategoryObject] = []
    @Environment(\.dismiss) var dismiss
    var mangaId: String
    var sourceId: String
    var isLocalSource: Bool = false
    var localSourceId: UUID? = nil
    @State var selectedCategories: [CategoryObject] = []
    var body: some View {
        VStack {
            HStack {
                Text("Select Categories")
                    .font(.title)
                Button {
                    addCategoriesToManga()
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
            List(categories) { category in
                HStack {
                    Text(category.categoryId ?? "")
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    if self.selectedCategories.contains(category) {
                        self.selectedCategories = self.selectedCategories.filter({ currentCategory in
                            currentCategory != category
                        })
                    }
                    else {
                        self.selectedCategories.append(category)
                        
                    }
                }
                
            }
        }
        .onAppear {
            fetchCategoryList()
            if let libraryEntry = CoreDataManager.shared.getLibraryEntryFromId(id: mangaId) {
                let categories = libraryEntry.categoriesArray
                for category in categories {
                    self.selectedCategories.append(category)
                }
            }
        }
    }
}

private extension AddToCategoryView {
    private func fetchCategoryList() {
        let request = CategoryObject.all()
        if let results = try? CoreDataManager.shared.viewContext.fetch(request) {
            for category in results {
                self.categories.append(category)
            }
        }
    }
    private func addCategoriesToManga() {
        let context = CoreDataManager.shared.viewContext
        let categories = NSSet(array: self.selectedCategories)
        if let libraryEntry = CoreDataManager.shared.getLibraryEntryFromId(id: mangaId) {
            libraryEntry.categories = categories
        }
        try? context.save()
    }
}

//struct AddToCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToCategoryView()
//    }
//}
