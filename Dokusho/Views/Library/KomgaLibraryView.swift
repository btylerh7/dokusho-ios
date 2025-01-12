//
//  KomgaLibraryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import OSLog

public enum LibraryLoadState: Equatable {
    case loading
    case loaded
    case error
}

struct KomgaLibraryView: View {
    @Environment(RouterPath.self) private var routerPath
    @Environment(Theme.self) private var theme
    @Environment(NetworkManager.self) private var client
    @Binding var id: String
    @Binding var title: String
    
    @State private var loadingState: LibraryLoadState = .loading
    @State var allSeries: AllSeries? = nil
    @State var collections: AllCollections? = nil
    @State var currentCollection: [Series] = []
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        ScrollView() {
           
            switch loadingState {
            case .loading:
                ProgressView()
            case .loaded:
                if allSeries == nil || allSeries?.content == nil {
                    noLibraryView
                } else {
                    LazyVGrid(columns: columns) {
                        if title == "All" {
                            ForEach(allSeries!.content, id: \.self.id) { series in
                                NewMangaTileView(series: series)
                                    .onTapGesture {
                                        routerPath.navigate(to: .series(series: series))
                                    }
                            }
                        }
                        else {
                            ForEach(currentCollection, id:\.self) { collection in
                                    NewMangaTileView(series: collection)
                                    .onTapGesture {
                                        routerPath.navigate(to: .series(series: collection))
                                    }
                            }
                        }
                        
                    }
                }
            case .error:
                Text("Loading Error")
            }
            
        }
        .task { await getCollection(id: id) }
        .onChange(of: id, { _, newValue in
            print("loading \(title)")
            Task {
                await getCollection(id: newValue)
            }
        })
        .background(theme.secondaryColor)
        .refreshable { Task { await getAllSeries() } }
    }
    public var noLibraryView: some View =
        VStack {
            Text("No series in your library ):")
        }
    
    func getAllSeries() async {
        loadingState = .loading
        allSeries = await client.getAllSeries()
        if let allSeries = allSeries {
            Logger.clientLogger.info("Getting tags")
            let result = client.getTags(seriesList: allSeries.content)
            Logger.clientLogger.debug("Tags are \(result)")
        }
        loadingState = .loaded
    }
    
    func getAllCollections() async {
        collections = await client.getAllCollections()
    }
    func getCollection(id: String) async {
        if id.isEmpty {
            await getAllSeries()
            return
        }
        guard let result = await client.getCollection(id) else {return}
        var results: [Series] = []
        for id in result.seriesIds {
            if let series = await client.getSingleSeries(seriesId: id) {
                results.append(series)
            }
        }
        currentCollection = results
    }
}



//struct KomgaLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaLibraryView(title: "Test")
//    }
//}
