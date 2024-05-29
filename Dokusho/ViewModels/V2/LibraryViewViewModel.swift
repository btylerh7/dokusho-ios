//
//  LibraryViewViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

@MainActor
final public class LibraryViewViewModel: ObservableObject {
    @Published var allSeries: AllSeries?
    @Published var collections: AllCollections?
    @Published var currentCollection: [Series] = []
    
    init() {
        Task {
            await getAllSeries()
            await getAllCollections()
            
        }
    }
    
    func getAllSeries() async {
        let result = await ApiService.shared.get(endpoint: .allSeries, type: AllSeries.self)
        self.allSeries = result
    }
    
    func getAllCollections() async {
        let result = await ApiService.shared.get(endpoint: .collections, type: AllCollections.self)
        self.collections = result
    }
    func getCollection(id: String) async {
        guard let result = await ApiService.shared.get(endpoint: .collection(id: id), type: Collection.self) else {return}
        var results: [Series] = []
        for id in result.seriesIds {
            if let series = await ApiService.shared.get(endpoint: .singleSeries(id: id), type: Series.self) {
                results.append(series)
            }
        }
        self.currentCollection = results
        
        
    }
}
