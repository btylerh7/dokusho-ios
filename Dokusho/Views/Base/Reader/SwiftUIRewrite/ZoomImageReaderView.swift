//
//  ZoomImageReaderView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/20/23.
//

import SwiftUI
import UIKit


struct ZoomImageReaderView: View {
    let chapter: Chapter
    let source: Source
    
    @State var isHidden = false
    @State var selectedIndex = 0
    @State var scannedText = ""
    @State var isPresentingScannedTextView = false
    @State var pages: [ChapterPage] = []
    
    @StateObject var viewModel = ReaderViewModel(provider: CoreDataManager.shared)
    var body: some View {
        NavigationStack {
            VStack {
                ExtractedView(chapter: chapter, source: source, isHidden: $isHidden, selectedIndex: $selectedIndex, scannedText: $scannedText, isPresentingScannedTextView: $isPresentingScannedTextView, pages: $pages)
                Text("Page \(selectedIndex + 1) of \(viewModel.totalPagesObservable.value)")
            }
        }
        .onAppear {
            viewModel.getChapterDetails(chapter: chapter, source: source)
        }
        .onChange(of: viewModel.startingPage) { newValue in
            selectedIndex = newValue
        }
        .onChange(of: viewModel.chapterDetails, perform: { newValue in
            guard let chapter = newValue else {return}
            pages = chapter.pages
        })
        .onChange(of: selectedIndex) { newValue in
            viewModel.currentPageObservable.value = String(newValue + 1)
        }
        .onChange(of: scannedText) { _ in
            isPresentingScannedTextView = true
        }
        .onDisappear {
            viewModel.handleDismiss(isLocalSource: false, source: source)
        }
    }
}

struct ZoomImageReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZoomImageReaderView(chapter: Chapter(mangaId: "oshi-no-ko", chapterId: "oshi-no-ko-chapter-1", chapNum: 1.0, chapNumString: "1"), source: Source(sourceId: "rawkuma", sourceTitle: "Rawkuma", baseUrl: "https://rawkuma.com", lang: "ja", sourceType: "image"))
    }
}

struct ExtractedView: View {
    @Environment(\.dismiss) var dismiss
    let chapter: Chapter
    let source: Source
    @Binding var isHidden: Bool
    @Binding var selectedIndex: Int
    @Binding var scannedText: String
    @Binding var isPresentingScannedTextView: Bool
    @Binding var pages: [ChapterPage]
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(pages, id:\.self) { page in
                ImageZoomView(imageUrl: page.link, scannedText: scannedText)
                    .tag(pages.firstIndex(of: page) ?? 0)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle("Chapter \(chapter.chapNumString)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isHidden == false {
                ToolbarItem(placement:.navigationBarLeading) {
                    Image(systemName: "x.circle.fill")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}
