//
//  SourcesView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI

final class SourcesViewModel: ObservableObject {
    @Published var sources: [Source] = SourceManager.shared.getAllSources()
}

struct SourcesView: View {
    @State var isPresentingAddSourceModal = false
    @StateObject var viewModel = SourcesViewModel()
    var body: some View {
        
        List(viewModel.sources, id:\.self) {source in
            NavigationLink(value: source) {
                Text(source.sourceTitle)
            }
        }
        .navigationTitle("Sources")
        .navigationDestination(for: Source.self) { source in
            SingleSourceView(source: source)
        }
        .navigationDestination(for: MangaTile.self) { tile in
            MangaDetailsView(manga: tile)
        }
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SourcesView()
        }
    }
}
