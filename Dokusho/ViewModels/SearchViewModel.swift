//
//  SearchViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/8/23.
//

import Foundation

@MainActor
final public class SearchViewModel {
    var selectedSource: Source = SourceManager.shared.sources[0]
    var selectedSourceObservable = ObservableItem(SourceManager.shared.sources[0])
    var tiles: [MangaTile] = []
    var tilesObservable: ObservableItem<[MangaTile]> = ObservableItem([])
    
    func updateSource(source: Source) {
        DispatchQueue.main.async {
            self.selectedSource = source
            self.selectedSourceObservable.value = source
        }
    }
    public func searchMangaTilesV2(query: String) async throws{
        let service = SourceAPIManager(sourceId: self.selectedSource.sourceId)
        let searchResults = try await service.sourceAPI.getSearchResults(source: self.selectedSource, query: query.replacing(" ", with: "+"))
        self.tiles = searchResults
        self.tilesObservable.value = searchResults
    }
}
