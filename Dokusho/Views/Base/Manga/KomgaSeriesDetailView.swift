//
//  KomgaSeriesDetailView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import OSLog

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
    @Environment(NetworkManager.self) private var client
    @State var series: Series
    @State var presentingReader: Bool = false
    @State var selectedBook: Book? = nil
    @State var pageToUpdate: Int? = nil
    @State var bookIdToUpdate: String? = nil
    @State var books: [Book] = []
    @State var authors: String = ""
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                KomgaSeriesDetailHeaderView(series: $series, authors: $authors)

                LazyVGrid(columns: columns) {
                    ForEach(books, id: \.self.id) { book in
                        BookTileView(book: book)
                            .onTapGesture {
                                selectedBook = book
                                bookIdToUpdate = book.id
                                if selectedBook != nil {
                                    presentingReader = true
                                }
                            }
                    }
                }
            }
            
            .task { await getBooksForSeries(seriesId: series.id) }
            .navigationTitle(series.metadata.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .refreshable {
            Task {
                await getBooksForSeries(seriesId: series.id)
            }
        }
        .fullScreenCover(item: $selectedBook, onDismiss: { }) { book in
            KomgaReaderView(book: book)
        }
    }
    
}

extension KomgaSeriesDetailView {
    func getBooksForSeries(seriesId: String) async {
        Logger.mangaDetailView.info("Getting Books for series \(seriesId)")
        guard let results = await client.getBooksForSeries(seriesId) else {
            Logger.mangaDetailView.error("No Books Found for \(seriesId)")
            return
        }
        self.books = results
        getAuthors()
    }
    func updateProgress(page: Int?, id: String?) async {
        guard let page = page else {
            Logger.mangaDetailView.error("Error updating reading progress: page is null")
            return
        }
        guard let id = id else {
            Logger.mangaDetailView.error("Error updating reading progress: id is null")
            return
        }
        guard let bookToUpdate = books.first(where: {$0.id == id}) else {return}
        Logger.mangaDetailView.info("Updating page \(page) for book id \(id)")
        let resultingProgress = await client.setReadingProgress(bookId: id, page: page, total: bookToUpdate.media.pagesCount)
        if let index = books.firstIndex(where: { $0.id == id }) {
            Logger.mangaDetailView.debug("Book's index is \(index)")
            guard books[index].readProgress != nil else {return}
            books[index].readProgress!.page = page
            Logger.mangaDetailView.debug("Page is set to \(page)")
        }
    }
    func getNewProgress(_ bookId: String) async {
        guard let readProgress = await client.getReadProgress(bookId) else {return}
        guard let index = self.books.firstIndex(where: { book in
            book.id == bookId
        }) else {
            return
        }
        books[index].readProgress = readProgress
    }
    func getBookProgress() async {
        print("Getting progress")
        guard let selectedBook = selectedBook else {return}
        guard let readProgress = await client.getReadProgress(selectedBook.id) else {return}
        if let index = books.firstIndex(of: selectedBook) {
            
            selectedBook.readProgress = readProgress
            books[index] = selectedBook
            self.selectedBook = nil
        }
    }
    func getAuthors() {
        var authorsList: [String] = []
        for book in books {
            for author in book.metadata.authors {
                authorsList.append(author.name)
            }
        }
            authors = authorsList.joined(separator: ", ")
    }
}

//struct KomgaSeriesDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaSeriesDetailView()
//    }
//}
