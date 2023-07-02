//
//  CoreDataManager+History.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
// Some functions taken from Aidoku application:
// https://github.com/btylerh7/Aidoku/blob/main/Shared/Data/Database/Objects/HistoryObject.swift

import Foundation
import CoreData

extension CoreDataManager {
    func getHistoryForManga(mangaId: String, sourceId: String, context: NSManagedObjectContext? = nil) -> [HistoryObject]{
        let viewContext = context ?? CoreDataManager.shared.viewContext
        let request = HistoryObject.fetchRequest()
        request.predicate = NSPredicate(
            format: "mangaId == %@ AND sourceId == %@ ",
            mangaId, sourceId
        )
        request.fetchLimit = 1
        return (try? viewContext.fetch(request)) ?? []
        
    }
    func createHistoryFromChapter(chapter: Chapter, context: NSManagedObjectContext? = nil, source: Source, progress: Int16, total: Int16, chapterObject: ChapterObject? = nil) -> HistoryObject {
        let viewContext = context ?? CoreDataManager.shared.viewContext
        let historyObject = HistoryObject(context: viewContext)
        historyObject.mangaId = chapter.mangaId
        historyObject.sourceId = source.sourceId
        historyObject.chapterId = chapter.chapterId
        historyObject.progress = progress
        historyObject.total = total
        historyObject.completed = progress >= total ? true : false
        if chapterObject != nil {
            historyObject.chapter = chapterObject
        }
        
        return historyObject
        
    }
    
    func getHistoryForChapter(chapter: Chapter, source: Source, context: NSManagedObjectContext? = nil) -> HistoryObject? {
        let context = context ?? CoreDataManager.shared.viewContext
        let request = HistoryObject.fetchRequest()
        request.predicate = NSPredicate(format: "chapterId == %@ AND mangaId == %@ AND sourceId == %@", chapter.chapterId, chapter.mangaId, source.sourceId)
//        request.fetchLimit = 1
//        print(try? context.fetch(request))
        return (try? context.fetch(request))?.first
    }
    
    func updateHistoryObject(progress: Int, total: Int, chapter: Chapter, source: Source, context: NSManagedObjectContext? = nil) {
        let context = context ?? CoreDataManager.shared.viewContext
        guard let historyObject = getHistoryForChapter(chapter: chapter, source: source, context: context) else {
            print("No history object for chapter \(chapter.chapNum)")
            return
        }
        historyObject.progress = Int16(exactly: progress)!
        historyObject.total = Int16(exactly: total)!
        
        try? context.save()
        
    }
}
