//
//  CoreDataManager+Chapter.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    func getChapterFromId(chapterId:String, sourceId: String, context: NSManagedObjectContext? = nil) -> ChapterObject?{
        print("Starting get from id")
        let context = context ?? CoreDataManager.shared.viewContext
        let request = ChapterObject.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND sourceId == %@ ",
            chapterId, sourceId
        )
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first ?? nil
        
    }
    
    /// Get the chapter objects for a manga.
    func getChapters(sourceId: String, mangaId: String, context: NSManagedObjectContext? = nil) -> [ChapterObject] {
        let context = context ?? self.viewContext
        let request = ChapterObject.fetchRequest()
        request.predicate = NSPredicate(
            format: "mangaId == %@ AND sourceId == %@",
            mangaId, sourceId
        )
        return (try? context.fetch(request)) ?? []
    }
    
    /// Create a Chapter object from a Core Data entity
    func createChapterFromChapterEntry(chapterEntry: ChapterObject) -> Chapter? {
        guard case _ = chapterEntry.mangaId != nil, chapterEntry.id != nil else {
            return nil
        }
        let chapter = Chapter(mangaId: chapterEntry.mangaId!, chapterId: chapterEntry.id!, chapNum: chapterEntry.chapter, chapNumString: String(describing: chapterEntry.chapter))
        
        return chapter
    }
    
    /// Create a ChapterObject Core Data entity from a Chapter object
    func createChapterObject(chapter: Chapter, context: NSManagedObjectContext? = nil, source: Source) -> ChapterObject {
        let context = context ?? self.viewContext
        let chapterEntry = ChapterObject(context: context)
        chapterEntry.mangaId = chapter.mangaId
        chapterEntry.chapter = chapter.chapNum
        chapterEntry.sourceId = source.sourceId
        chapterEntry.id = chapter.chapterId
        chapterEntry.title = "Chapter \(chapter.chapNumString)"
        chapterEntry.lang = source.lang
        chapterEntry.url = source.baseUrl.appending("/\(chapter.chapterId)")
        
        return chapterEntry
    }
}
