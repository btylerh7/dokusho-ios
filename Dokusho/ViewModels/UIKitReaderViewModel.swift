//
//  UIKitReaderViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/15/23.
//

import Foundation
import SwiftUI
import UIKit

public class UIKitReaderViewModel: ObservableObject {
    @Published var pages: [ChapterPage] = []
    @Published var currentPage: Int
    @Published var chapter: Chapter
    var source: Source
    
    init(currentPage: Int?, chapter: Chapter, source: Source) {
        self.currentPage = currentPage ?? 1
        self.chapter = chapter
        self.source = source
        Task {
            await getChapterDetails()
        }
    }
    
    
    func getChapterDetails() async {
        let sourceManager = SourceAPIManager(sourceId: source.sourceId)
        let results = try? await sourceManager.sourceAPI.getChapterDetails(source: source, chapterId: chapter.chapterId, mangaId: chapter.mangaId)
        DispatchQueue.main.async {
            self.pages = results?.pages ?? []

        }
    }
}
