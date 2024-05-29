//
//  KomgaSeriesDetailViewViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

final public class KomgaSeriesDetailViewViewModel: ObservableObject {
    @Published var books: Books? = nil
    @Published var authors: String = ""
    
    public func getBooksForSeries(seriesId: String) async {
        let result = await Komgav2APIService.shared.getBooksForSeries(seriesId: seriesId)
        DispatchQueue.main.async { [weak self] in
            self?.books = result
            self?.getAuthors()
            
        }
    }
    private func getAuthors() {
        var authorsList: [String] = []
        for book in books?.content ?? [] {
            for author in book.metadata.authors {
                authorsList.append(author.name)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.authors = authorsList.joined(separator: ", ")
        }
    }
    
}
