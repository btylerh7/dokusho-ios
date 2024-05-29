//
//  SingleSourceView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI

final class SingleSourceViewModel: ObservableObject {
    @Published var tiles: [MangaTile] = []
    
    func getHomepageResults(source: Source) {
        print("Starting to get results for homepage on \(source.sourceTitle)")
        Task {
            let service = SourceAPIManager(sourceId: source.sourceId)
            let results = try? await service.sourceAPI.getHomepageResults(source: source)
            if results != nil {
                DispatchQueue.main.async {
                    self.tiles = results ?? []
                }
            }
        }
    }
}

struct SingleSourceView: View {
    @Environment(Theme.self) private var theme
    @StateObject var viewModel = SingleSourceViewModel()
    let source: Source
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.tiles, id:\.self) {tile in
                    NavigationLink(value: tile) {
                        MangaTileView(title: tile.title, image:tile.image, sourceId: tile.sourceId)
                    }
                    
                }
                
            }
            .navigationTitle(source.sourceTitle)
            .onAppear {
                viewModel.getHomepageResults(source: source)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .background(theme.secondaryColor)

    }
}

struct SingleSourceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SingleSourceView(source: Source(sourceId: "rawkuma", sourceTitle: "Rawkuma", baseUrl: "https://rawkuma.com", lang: "ja", sourceType: "image"))
//            SingleSourceView(source: Source(sourceId: "manga1000", sourceTitle: "Manga 1000", baseUrl: "https://manga1000.top", lang: "ja", sourceType: "image"))
        }
    }
}
