//
//  KomgaLibraryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI

struct KomgaLibraryView: View {
    @Environment(Theme.self) private var theme
    @Binding var id: String
    @Binding var title: String
    @StateObject var viewModel: LibraryViewViewModel
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        ScrollView() {
            
            if viewModel.allSeries == nil {
                ProgressView()
            }
            else {
                LazyVGrid(columns: columns) {
                    if title == "All" {
                        ForEach(viewModel.allSeries!.content, id: \.self.id) { series in
                            NavigationLink(value: series) {
                                NewMangaTileView(series: series)
                            }
                        }
                    }
                    else {
                        ForEach(viewModel.currentCollection, id:\.self) { collection in
                            NavigationLink(value: collection) {
                                NewMangaTileView(series: collection)
                            }
                        }
                    }
                    
                }
                .navigationDestination(for: Series.self) { series in
                    KomgaSeriesDetailView(series: series)
                }
                
            }
        }
        .task {
            if id != "" {
                await viewModel.getCollection(id: id)
            }
        }
        .onChange(of: id, perform: { newValue in
            print("loading \(title)")
            if newValue != "" {
                Task {
                    await viewModel.getCollection(id: newValue)
                }
            }
        })
        .background(theme.secondaryColor)
        .refreshable {
            Task { await viewModel.getAllSeries() }
        }
    }
    public var noLibraryView: some View =
        VStack {
            Text("No series in your library ):")
        }
}



//struct KomgaLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaLibraryView(title: "Test")
//    }
//}
