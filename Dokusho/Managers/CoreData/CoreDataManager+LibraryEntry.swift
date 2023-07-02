//
//  CoreDataManager+LibraryEntry.swift
//  Manga Reader App
//
//  Created by Tyler Baker on 3/16/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    /// Check if an object exists in library
    
    func hasLibraryObject(id: String, sourceId: String, context: NSManagedObjectContext? = nil) -> Bool {
        do {
            let context = context ?? self.viewContext
            let request = LibraryEntryObject.fetchRequest()
            request.predicate = NSPredicate(format: "mangaId == %@ AND sourceId == %@", id, sourceId)
            request.fetchLimit = 1
            return (try context.count(for: request)) > 0
        }
        catch {
            print("error: \(error.localizedDescription)")
            return false
        }
    }
    
    func addToLibrary(mangaDetails: MangaDetails, source: Source, context: NSManagedObjectContext? = nil) {
        print(mangaDetails.sourceId)
        let context = context ?? self.viewContext
        if hasLibraryObject(id: mangaDetails.mangaId, sourceId: source.sourceId, context: context) == true {
            print("source already exists in library")
            return
        }
        context.perform {
            let mangaEntry = MangaObject(context: context)
            mangaEntry.id = mangaDetails.mangaId
            mangaEntry.author = mangaDetails.author
            mangaEntry.desc = mangaDetails.description
            mangaEntry.image = mangaDetails.image
            mangaEntry.sourceId = mangaDetails.sourceId
            mangaEntry.title = mangaDetails.title
            
            
            let libraryEntry = LibraryEntryObject(context: context)
            libraryEntry.sourceId = source.sourceId
            libraryEntry.image = mangaEntry.image
            libraryEntry.manga = mangaEntry
            mangaEntry.libraryEntry = libraryEntry
            libraryEntry.title = mangaEntry.title
            libraryEntry.mangaId = mangaEntry.id
            
            
            try? context.save()
        }
        
    }
    func getLibraryEntryFromId(id: String, context: NSManagedObjectContext? = nil) -> LibraryEntryObject? {
        let context = context ?? self.viewContext
        let request = LibraryEntryObject.fetchRequest()
        request.predicate = NSPredicate(format: "mangaId == %@", id)
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first ?? nil
    }
    func removeLibraryEntry(libraryEntry: LibraryEntryObject, context: NSManagedObjectContext? = nil) {
        let context = context ?? CoreDataManager.shared.viewContext
        let mangaEntry = libraryEntry.manga
        if mangaEntry != nil {
            context.delete(mangaEntry!)
        }
        let chapterRequest = ChapterObject.fetchRequest()
        chapterRequest.predicate = NSPredicate(format: "mangaId == %@ AND sourceId == %@", libraryEntry.mangaId ?? "", mangaEntry?.sourceId ?? "")
        self.clear(request: chapterRequest, context: context)
        
        let historyRequest = HistoryObject.fetchRequest()
        historyRequest.predicate = NSPredicate(format: "mangaId == %@ AND sourceId == %@", libraryEntry.mangaId ?? "", mangaEntry?.sourceId ?? "")
        self.clear(request: historyRequest, context: context)
    
        context.delete(libraryEntry)
        
        try? context.save()
    }
    
}
