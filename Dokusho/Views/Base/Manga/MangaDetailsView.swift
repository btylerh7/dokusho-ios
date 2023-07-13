//
//  MangaDetailsView.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/19/23.
//

import SwiftUI
import NukeUI

struct MangaDetailsView: View {
    let manga: MangaTile
    @State var isPresentingReaderView = false
    @State var selectedChapter: Chapter? = nil
    @State var chapterIterators: [ChapterIterator] = []
//    let source: Source
    @State var viewModel: MangaChapterTableViewModel
    
    init(manga: MangaTile) {
        self.manga = manga
//        self.source = source
        self.viewModel = MangaChapterTableViewModel(provider: CoreDataManager.shared, mangaId: manga.mangaId)
    }
    
    var header: some View {
        MangaDetailsHeaderView(mangaTile: manga, viewModel: viewModel)
    }
    var body: some View {
        List {
            Section(header: header.frame(maxWidth: .infinity)) {
                ForEach(chapterIterators, id: \.self) { chapterIterator in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Chapter \(chapterIterator.chapter.chapNumString)")
                                if chapterIterator.progress != nil {
                                    Text("\(String(describing: chapterIterator.progress!)) of \(String(describing: chapterIterator.total!))")
                                        .font(.caption2)
                                }
                            }
                            .foregroundColor(chapterIterator.progress != nil ? Color(.secondaryLabel) : Color(.label))
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                    .onTapGesture {
                        if selectedChapter == chapterIterator.chapter {
                            isPresentingReaderView = true
                        }
                        selectedChapter = chapterIterator.chapter
                    }
                }
                
            }
            .listRowBackground(ThemeManager.shared.currentTheme.listBackgroundColor)
        }
        .scrollContentBackground(.hidden)
        .background(ThemeManager.shared.currentTheme.secondaryColor)
        .listStyle(.insetGrouped)
        .onAppear {
            viewModel.getMangaChapters(manga: manga, source: SourceManager.shared.getSourceFromId(sourceId: manga.sourceId))
            viewModel.chaptersObservable.bind { _ in
                viewModel.createChapterIteratorV2()
            }
            viewModel.chapterIteratorObservable.bind { iterators in
                chapterIterators = iterators
            }
        }
        .onChange(of: selectedChapter, perform: { _ in
            isPresentingReaderView = true
        })
        .refreshable {
            refreshData()
        }
        .fullScreenCover(isPresented: $isPresentingReaderView, onDismiss: {
            viewModel.createChapterIteratorV2()
            refreshData()
        }) {
//            ReaderViewWrapper(chapter: selectedChapter!, source: SourceManager.shared.getSourceFromId(sourceId: manga.sourceId))
                ZoomImageReaderView(chapter: selectedChapter!, source: SourceManager.shared.getSourceFromId(sourceId: manga.sourceId))
        }
    }
}

extension MangaDetailsView {
    func refreshData() {
        viewModel.chaptersObservable.value = []
        viewModel.getMangaChapters(manga: manga, source: SourceManager.shared.getSourceFromId(sourceId: manga.sourceId))
    }
}

struct MangaDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {        MangaDetailsView(manga: MangaTile(sourceId: "rawkuma", mangaId: "oshi-no-ko", title: "Oshi No Ko", image: "https://rawkuma.com/wp-content/uploads/2020/06/Oshi-no-Ko.jpg"))
    }
}

