//
//  AddToCategoryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/19/23.
//

import SwiftUI
import SwiftData

struct AddToCategoryView: View {
    @Query var categories: [CategoryItem]
    @Query var libraryItems: [LibraryItem]
    @Environment(\.dismiss) var dismiss
    var mangaId: String
    var sourceId: String
    var isLocalSource: Bool = false
    var localSourceId: UUID? = nil
    @State var selectedCategories: [CategoryItem] = []
    init(mangaId: String, sourceId: String, isLocalSource: Bool = false, localSourceId: UUID? = nil) {
        
        let predicate = #Predicate<LibraryItem> { item in
            item.mangaId == mangaId && item.sourceId == sourceId
        }
        _libraryItems = Query(filter: predicate)
        
        self.mangaId = mangaId
        self.sourceId = sourceId
        self.isLocalSource = isLocalSource
        self.localSourceId = localSourceId
        self.selectedCategories = selectedCategories
    }
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
                    Text(category.categoryId)
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
    }
}

private extension AddToCategoryView {
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
