//
//  CoreDataManager+Manga.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    
    /// Get a particular manga object.
    func getMangaFromId(mangaId: String, sourceId: String, context: NSManagedObjectContext? = nil) -> MangaObject? {
        let viewContext = context ?? CoreDataManager.shared.viewContext
        let request = MangaObject.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND sourceId == %@ ",
            mangaId, sourceId
        )
        request.fetchLimit = 1
        return (try? viewContext.fetch(request))?.first
    }
    
    /// Creates a MangaDetails object from a MangaEntry
    func createMangaDetails(mangaEntry: MangaObject, context: NSManagedObjectContext? = nil) -> MangaDetails {
        let context = context ?? CoreDataManager.shared.viewContext
        var details: MangaDetails? = nil
        context.performAndWait {
            details = MangaDetails(sourceId: mangaEntry.sourceId ?? "", mangaId: mangaEntry.id ?? "", title: mangaEntry.title ?? "", image: mangaEntry.image ?? "", description: mangaEntry.desc ?? "" , author: mangaEntry.author ?? "Unknown")
        }
        return details!
    }
    
    /// Creates a MangaObject from a MangaDetails object
    func createManga(manga: MangaDetails, context: NSManagedObjectContext? = nil) -> MangaObject? {
        let context = context ?? self.viewContext
        let existingManga = getMangaFromId(mangaId: manga.mangaId, sourceId: manga.sourceId)
        if  existingManga != nil {
            print("manga already exists")
            return existingManga
        }
        
        let mangaEntry = MangaObject(context: context)
        mangaEntry.sourceId = manga.sourceId
        mangaEntry.id = manga.mangaId
        mangaEntry.title = manga.title
        mangaEntry.author = manga.author
        mangaEntry.image = manga.image
        
        return mangaEntry
    }
}
    
    

