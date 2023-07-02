//
//  CategoryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI

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
    let selectedCategory: String
    @StateObject var viewModel = CategoryViewModel()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.tiles, id:\.self) { tile in
                        NavigationLink(value: tile) {
                            MangaTileView(title: tile.title, image:tile.image, sourceId: tile.sourceId)

                        }
                    }
                }
                .navigationTitle(selectedCategory)
                .onAppear {
                    viewModel.getTiles(selectedCategory: selectedCategory)
                }
                .navigationDestination(for: MangaTile.self) { tile in
                    MangaDetailsView(manga: tile)
                }
            }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(selectedCategory: "All")
    }
}
