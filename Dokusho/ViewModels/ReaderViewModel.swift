//
//  ReaderViewController.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/4/23.
//

import Foundation
import CoreData
import UIKit
import ZIPFoundation

@MainActor
final public class ReaderViewModel: ObservableObject {
    var context: NSManagedObjectContext
    @Published var chapterDetails: ChapterDetails? = nil
    @Published var chapter: Chapter? = nil
    @Published var startingPage: Int = 0
    var imagesObservable: ObservableItem<[UIImage]> = ObservableItem([])
    var chapterDetailsObservable: ObservableItem<ChapterDetails?> = ObservableItem(nil)
    @Published var currentPageObservable: ObservableItem<String> = ObservableItem("")
    @Published var totalPagesObservable: ObservableItem<String> = ObservableItem("")
    var isHiddenObservable: ObservableItem<Bool> = ObservableItem(false)
    var currentFont = UIFont.preferredFont(forTextStyle: .body)
    @Published var pagesObservable: ObservableItem<[[String]]> = ObservableItem([])
    @Published var scannedTextObservable: ObservableItem<String> = ObservableItem("")

    
    init(provider: CoreDataManager) {
        self.context = provider.newContext
    }
    
    func getChapterDetails(chapter: Chapter, source: Source) {
        print("Getting chapter details")
        self.chapter = chapter
        Task {
            let service = SourceAPIManager(sourceId: source.sourceId)
            let results = try? await service.sourceAPI.getChapterDetails(source: source, chapterId: chapter.chapterId, mangaId: chapter.mangaId)
            if results != nil {
                self.chapterDetails = results!
                self.chapterDetailsObservable.value = results!
                self.totalPagesObservable.value = String(results!.pages.count)
            }
            await context.perform {
                if let history = CoreDataManager.shared.getHistoryForChapter(chapter: chapter, source: source, context: self.context) {
                    let progress = history.progress
                    DispatchQueue.main.async {
                        self.startingPage = Int(progress - 1)
                    }
                    self.currentPageObservable.value = String(progress)
                }
                else {
                    DispatchQueue.main.async {
                        self.currentPageObservable.value = "1"

                    }
                }
            }
            
        }
    }
    
    func handleDismiss(isLocalSource: Bool, source: Source? = nil) {
        context.performAndWait { [weak self] in
            guard let self = self else {return}
            let hasSource = CoreDataManager.shared.hasLibraryObject(id: self.chapter!.mangaId, sourceId: source!.sourceId, context: self.context)
            
            
            if hasSource == true {
                if let _ = CoreDataManager.shared.getHistoryForChapter(chapter: self.chapter!, source: source!, context: self.context) {
                    CoreDataManager.shared.updateHistoryObject(progress: Int(self.currentPageObservable.value)!, total: Int(self.totalPagesObservable.value)!, chapter: self.chapter!, source: source!, context: self.context)
                }
                else {
                    let chapterEntry = CoreDataManager.shared.createChapterObject(chapter: self.chapter!, context: self.context, source: source!)
                    let historyEntry = CoreDataManager.shared.createHistoryFromChapter(chapter: self.chapter!, context: self.context, source: source!, progress: Int16(self.currentPageObservable.value)!, total: Int16(self.totalPagesObservable.value)!)
                    historyEntry.chapter = chapterEntry
                    let mangaEntry = CoreDataManager.shared.getMangaFromId(mangaId: self.chapter!.mangaId, sourceId: source!.sourceId, context: self.context)
                    mangaEntry?.addToHistory(historyEntry)
                    print("added chapter to library manga")
                    print(String(describing: mangaEntry?.history?.count))
                }
                try! self.context.save()
            }
        }
        
    }
    
    func getCharactersPerLine(pageSize: CGSize ) -> Int {
        let lineRect = "X".boundingRect(with: CGSize(width: pageSize.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: currentFont], context: nil)
        return Int((pageSize.width / currentFont.pointSize).rounded())
    }
    func splitIntoLines(charactersPerLine: Int) -> [String]{
        let text = chapterDetailsObservable.value!.text!

        let lines = stride(from: 0, to: text.count, by: charactersPerLine).map { i -> String in
            let start = text.index(text.startIndex, offsetBy: i)
            let end = text.index(start, offsetBy: charactersPerLine, limitedBy: text.endIndex) ?? text.endIndex
            return String(text[start..<end])
        }
        return lines
    }
    func splitIntoPages(lines: [String], pageSize: CGSize) {
        var pages: [[String]] = []
        var currentPageHeight: CGFloat = 0
        var currentPage: [String] = []
        for line in lines {
            let lineHeight = line.boundingRect(with: CGSize(width: pageSize.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: currentFont], context: nil).height
            print("line height is: \(lineHeight)")
            print("page height is: \(pageSize.height)")
            if lineHeight + currentPageHeight < pageSize.height {
                currentPageHeight += lineHeight
                currentPage.append(line)
            }
            if lineHeight + currentPageHeight > pageSize.height {
                pages.append(currentPage)
                currentPage = []
                currentPageHeight = 0
            }
        }
        pages.append(currentPage)
        DispatchQueue.main.async {
            self.pagesObservable.value = pages
        }
    }
    
    func getChapterText(source: Source, chapter: Chapter) {
        self.chapter = chapter
        Task {
            let service = SourceAPIManager(sourceId: source.sourceId)
            let details = try? await service.sourceAPI.getChapterDetails(source: source, chapterId: chapter.chapterId, mangaId: chapter.mangaId)
            self.chapterDetailsObservable.value = details
        }
    }
}
