//
//  LibraryViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/6/23.
//

import Foundation

enum CategoryResultType {
    case online(MangaTile)
}

@MainActor
final public class CategoryFilterViewModel {
    var selectedCategory: String = ""
    var tiles: [LibraryEntryObject] = []
    var viewableTiles: [LibraryEntryObject] = []
    var viewableMangaTiles: Array<CategoryResultType> = []
    var viewableTilesObservable: ObservableItem<[LibraryEntryObject]> = ObservableItem([])
    var query: String = ""
    
    public func setup(selectedCategoryName: String) {
        self.selectedCategory = selectedCategoryName
        fetch()
    }
    
    public func reload() {
        viewableTilesObservable.value = []
        viewableMangaTiles = []
        viewableTiles = []
        fetch()
    }
    
    private func createTilesFromFetchResults(results: [LibraryEntryObject]? = nil) {
        
        if let results = results {
            self.viewableTiles = results
            print(self.viewableTiles.compactMap({ tile in
                return "\(tile.sourceId) series \(tile.mangaId!)"
            }))
        }
        else {
            for tile in self.tiles {
                self.viewableTiles = []
                self.viewableTiles.append(tile)
            }
        }
        self.viewableTilesObservable.value = self.viewableTiles
        for tile in self.viewableTiles {
            let mangaTile = MangaTile(sourceId: tile.manga!.sourceId!, mangaId: tile.mangaId!, title: tile.title!, image: tile.image!)
            self.viewableMangaTiles.append(.online(mangaTile))
        }
        self.viewableTilesObservable.value = viewableTiles
    }
    func fetch() {
        if self.selectedCategory == "All" {
            return fetchAll()
        }
        else {
            return fetchCategory()
        }
    }
    func fetchAll() {
        let request = LibraryEntryObject.all()
        if let results = try?
            CoreDataManager.shared.viewContext.fetch(request) {
            createTilesFromFetchResults(results: results)
        }
        sortTiles()
    }
    func fetchCategory() {
        let results = CoreDataManager.shared.getLibraryEntriesInCategory(categoryId: self.selectedCategory)
        createTilesFromFetchResults(results: results)
        sortTiles()
    }
}

extension CategoryFilterViewModel {
    func sortTiles() {
        let sortedTiles = self.viewableMangaTiles.sorted(by: { (result1, result2) -> Bool in
            switch (result1, result2) {
            case (.online(let tile1), .online(let tile2)):
                return tile1.title.localizedCaseInsensitiveCompare(tile2.title) == .orderedAscending
            }
        })
        DispatchQueue.main.async {
            self.viewableMangaTiles = sortedTiles
            print(self.viewableMangaTiles)
        }
    }
}




