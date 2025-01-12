//
//  AppRegistry.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/28/24.
//

import Foundation
import SwiftUI

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case .series(let series):
                KomgaSeriesDetailView(series: series)
            case .mangaTile(let tile):
//                MangaDetailsView(manga: tile)
                Text("NA")
            case .category(let category):
                Text("NA")
            }
        }
    }
    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
          switch destination {
            case .addCategoryModal:
                AddCategoryView()
            case .addToCategoryModal(let mangaId, let sourceId):
                AddToCategoryView(mangaId: mangaId, sourceId: sourceId)
            case .liveTextView(let imageToScan):
                LiveTextUIImageView(image: imageToScan)
            case .reader(let book):
                KomgaReaderView(book: book)
            case .scannedTextView(let text):
                VStack(spacing: 10) {
                    
                    Text("Scanned Text:")
                        .font(.title)
                    Text(text)
                        .textSelection(.enabled)
                    Spacer()
                }
                .padding()
            }
        }
    }
    func withEnvironments() -> some View {
        environment(Theme.shared)
            .environment(Client.shared)
            .environment(NetworkManager.shared)
    }
}
