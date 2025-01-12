//
//  KomgaCategorySelector.swift
//  Dokusho
//
//  Created by Tyler Baker on 8/1/23.
//

import SwiftUI
import OSLog

enum Filter {
    case all
    case filter(collection: String)
}

struct CategorySelectorTabItem: View {
    var tabName: String
    var body: some View {
        Text(tabName)
            .padding()
            .frame(minWidth: 20)
            .padding(.horizontal)
    }
}

struct LibraryView: View {
    @Environment(RouterPath.self) private var routerPath
    @Environment(Theme.self) private var theme
    @Environment(NetworkManager.self) private var client
    @State var allSeries: AllSeries? = nil
    
    @State var loadingState: LibraryLoadState = .loading
    @State var currentCollection: [Series] = []
    @State var allGenres: [String] = ["All"]
    @State var currentGenre: String = "All"
    
    var currentSeries: [Series] {
        if currentGenre == "All" {
            return allSeries?.content ?? []
        }
        else if let seriesList = allSeries?.content {
            return seriesList.filter({ series in
                return series.metadata.genres.contains(currentGenre)
            })

        }
        else {
            return [Series]()
        }
    }
    
    @State var collectionId: String = ""
    @State var title: String = "All"
    var body: some View {
        let background = theme.secondaryColor
        let accent = theme.primaryColor
        VStack {
            ScrollingTabView()
            ScrollView(.vertical) {
                switch loadingState {
                case .loading:
                    ProgressView()
                case .loaded:
                    GalleryView(series: currentSeries)
                case .error:
                    Text("Loading Error")
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .background(background)
            .foregroundColor(theme.textColor)
            .task {
                await getAllSeries()
            }
            .refreshable {
                await getAllSeries()
            }

        }
    }
    @ViewBuilder
    func ScrollingTabView() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(allGenres, id: \.self) { tag in
                    Button(action: {
                        withAnimation(.snappy) {
                            currentGenre = tag
                        }
                    }) {
                        Text(tag)
                            .foregroundStyle(tag == currentGenre ? Color.white : theme.textColor)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .background(tag == currentGenre ? theme.primaryColor : theme.listBackgroundColor, ignoresSafeAreaEdges: .horizontal)
                    .cornerRadius(10)
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.horizontal, 20)
        .safeAreaPadding(.vertical, 10)
        
    }
    
    @ViewBuilder
    func GalleryView(series: [Series]) -> some View {
        let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
        LazyVGrid(columns: columns) {
            ForEach(series, id: \.self.id) { current in
                NewMangaTileView(series: current)
                    .onTapGesture {
                        routerPath.navigate(to: .series(series: current))
                    }
            }
        }
    }
}
extension LibraryView {
    func getAllSeries() async {
        allSeries = await client.getAllSeries()
        let genres = client.getGenres(seriesList: allSeries?.content ?? [])
        self.allGenres = ["All"]
        self.allGenres.append(contentsOf: genres)
        loadingState = .loaded
    }
    func getAllCollections() async {
//        collections = await client.getAllCollections()
    }
    func getCollection(id: String) async {
        guard let result = await client.getCollection(id) else {return}
        
    }
}

struct KomgaCategorySelector_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
