//
//  CategoryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI
import SwiftData

final class CategoryViewModel: ObservableObject {
    @Published var tiles: [MangaTile] = []
    func getTiles(selectedCategory: String) {
        let entries = CoreDataManager.shared.getLibraryEntriesInCategory(categoryId: selectedCategory)
        for entry in entries {
            let tile = MangaTile(sourceId: entry.sourceId, mangaId: entry.mangaId!, title: entry.title!, image: entry.image!)
            tiles.append(tile)
        }
    }
}

struct CategoryView: View {
    @Environment(Theme.self) private var theme
    @Query var tiles: [CategoryItem]
    let selectedCategory: String
    var filteredItems: [MangaTile] = []
    init(category: String) {
        self.selectedCategory = category
        self.filteredItems = tiles.filter { mangaItem in
            return mangaItem.categoryId == category
        }.first?.libraryItems.map({ item in
            return MangaTile(sourceId: item.sourceId, mangaId: item.mangaId, title: item.title, image: item.image)
        }) ?? []
    }
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(filteredItems, id:\.self) { tile in
                        NavigationLink(value: tile) {
                            MangaTileView(title: tile.title, image:tile.image, sourceId: tile.sourceId)
                        }
                    }
                }
                .navigationTitle(selectedCategory)
                .navigationDestination(for: MangaTile.self) { tile in
                    MangaDetailsView(manga: tile)
                }
            }
            .background(theme.secondaryColor)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: "All")
    }
}
