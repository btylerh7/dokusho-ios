//
//  SearchView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/4/23.
//

import SwiftUI

final class SearchViewViewModel: ObservableObject {
    @Published var selectedSource: Source = SourceManager.shared.sources[0]
    @Published var tiles: [MangaTile] = []
    
    public func searchMangaTilesV2(query: String) async throws{
        let service = SourceAPIManager(sourceId: self.selectedSource.sourceId)
        let searchResults = try await service.sourceAPI.getSearchResults(source: self.selectedSource, query: query.replacing(" ", with: "+"))
        DispatchQueue.main.async {
            self.tiles = searchResults
        }
    }
}

struct SearchView: View {
    @StateObject var viewModel = SearchViewViewModel()
    @State var installedSources: [Source] = SourceManager.shared.sources
    @State var selectedSource = "rawkuma"
    @State public var path = NavigationPath()
    @State private var query = ""
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    HStack {
                        Picker("Select Source", selection: $selectedSource) {
                            ForEach(installedSources, id:\.self) { source in
                                Text(source.sourceId)
                                    .tag(source.sourceId)
                            }
                        }
                        Spacer()

                    }
                    .padding(.horizontal)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.tiles, id: \.self) { tile in
                            NavigationLink(value: tile) {
                                MangaTileView(title: tile.title, image: tile.image, sourceId: tile.sourceId)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onChange(of: self.selectedSource, perform: { sourceName in
                self.viewModel.selectedSource = SourceManager.shared.getSourceFromId(sourceId: sourceName)
            })
            .navigationDestination(for: MangaTile.self) { tile in
                MangaDetailsView(manga: tile)
                    .font(.headline)
                    .navigationBarBackButtonHidden()
                    .navigationBarItems(leading:
                                            Button {
                        path.removeLast()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Browse")
                        }
                    }
                    )
            }
            .navigationTitle("Search")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Type Manga Name")
            .onAppear {
                self.viewModel.selectedSource = SourceManager.shared.getSourceFromId(sourceId: selectedSource)
            }
            .onChange(of: query) { query in
                Task {
                    do {
                        try await viewModel.searchMangaTilesV2(query: query)
                    }
                    catch {
                        
                    }
                }
            }
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

