//
//  KomgaSeriesDetailView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI

struct KomgaSeriesTagPillView: View {
    @Environment(Theme.self) private var theme
    var title: String
    var body: some View {
        Text(title)
            .font(.caption)
            .padding(5)
            .foregroundColor(theme.textColor)
            .background(theme.primaryColor)
            .cornerRadius(10)
            
    }
}

struct KomgaSeriesDetailView: View {
    @State var series: Series
    @State var presentingReader: Bool = false
    @State var selectedBook: Book? = nil
    @StateObject var viewModel = KomgaSeriesDetailViewViewModel()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                KomgaSeriesDetailHeaderView(series: $series, authors: $viewModel.authors)

                if viewModel.books != nil {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.books!.content, id: \.self.id) { book in
                                BookTileView(book: book)
                                .onTapGesture {
                                    selectedBook = book
                                    if selectedBook != nil {
                                        presentingReader = true
                                    }
                                }
                        }
                    }
                }
            }
            
            .task {
                await viewModel.getBooksForSeries(seriesId: series.id)
            }
            .navigationTitle(series.metadata.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(item: $selectedBook, onDismiss: {
            selectedBook = nil
        }) { book in
            KomgaReaderView(book: book)
        }
    }
    
}

//struct KomgaSeriesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaSeriesDetailView()
//    }
//}
