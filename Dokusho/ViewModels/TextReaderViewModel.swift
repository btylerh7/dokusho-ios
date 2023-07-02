//
//  TextReaderViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/29/23.
//

import Foundation
import UIKit
import CoreData

@MainActor
final class TextReaderViewModel {
    var context: NSManagedObjectContext
    var chapterDetailsObservable: ObservableItem<ChapterDetails?> = ObservableItem(nil)
    var currentPageObservable: ObservableItem<Int> = ObservableItem(1)
    var totalPagesObservable: ObservableItem<Int> = ObservableItem(0)
    var isHiddenObservable: ObservableItem<Bool> = ObservableItem(false)
    
    var pagesObservable: ObservableItem<[[String]]> = ObservableItem([])
    var currentFont = UIFont.preferredFont(forTextStyle: .body)
    var chapter: Chapter? = nil
    
    init(provider: CoreDataManager) {
        self.context = provider.newContext
    }
    
    
    func getCharactersPerLine(pageSize: CGSize ) -> Int {
        let lineRect = "".boundingRect(with: CGSize(width: pageSize.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: currentFont], context: nil)
        return Int((lineRect.width / currentFont.pointSize).rounded())
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
        var currentPageHeight: CGFloat = 0
        var currentPage: [String] = []
        for line in lines {
            let lineHeight = line.boundingRect(with: CGSize(width: pageSize.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: currentFont], context: nil).height
            if lineHeight + currentPageHeight < pageSize.height {
                currentPageHeight += lineHeight
                currentPage.append(line)
            }
            if lineHeight + currentPageHeight > pageSize.height {
                pagesObservable.value.append(currentPage)
                currentPage = []
            }
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
    
    func handleDismiss(source: Source? = nil) {
        context.perform {
            let hasSource = CoreDataManager.shared.hasLibraryObject(id: self.chapter!.mangaId, sourceId: source!.sourceId, context: self.context)
            
            if hasSource == true {
                if let oldHistoryEntry = CoreDataManager.shared.getHistoryForChapter(chapter: self.chapter!, source: source!, context: self.context) {
                    print("has old entry \(oldHistoryEntry.progress)")
                    oldHistoryEntry.progress = Int16(exactly: self.currentPageObservable.value)!
                    oldHistoryEntry.total = Int16(exactly: self.totalPagesObservable.value)!
                    print("old history entry updated to: \(oldHistoryEntry.progress)")
                }
                try? self.context.save()
            }
        }
    }
}
