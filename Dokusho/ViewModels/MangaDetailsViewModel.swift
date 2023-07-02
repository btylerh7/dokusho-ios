////
////  MangaDetailsViewModel.swift
////  Dokusho
////
////  Created by Tyler Baker on 3/30/23.
////
//
//import Foundation
//import CoreData
//
//@MainActor
//final public class MangaDetailsViewModel {
//    
//    
//    init(provider: CoreDataManager, libraryEntry: LibraryEntryObject? = nil, mangaEntry: MangaObject? = nil) {
//        self.context = provider.newContext
//        self.libraryEntry = libraryEntry ?? LibraryEntryObject(context: self.context)
//        self.mangaEntry = mangaEntry ?? MangaObject(context: self.context)
//    }
//    
//
//    
//    
//    
//    /// Get basic information about the selected manga.
//    func getMangaDetails(mangaTile: MangaTile) {
//        Task {
//            let hasSource = CoreDataManager.shared.hasSource(id: mangaTile.mangaId, context: self.context)
//            if hasSource == true {
//                let details = CoreDataManager.shared.getMangaFromId(mangaId: mangaTile.mangaId, sourceId: mangaTile.sourceId)
//                if details != nil {
//                    DispatchQueue.main.async {
//                        self.mangaDetails = CoreDataManager.shared.createMangaDetails(mangaEntry: details!)
//                        self.mangaDetailsObservable.value = self.mangaDetails
//                        self.libraryEntry.image = details!.image
//                        self.libraryEntry.mangaId = details!.id
//                        self.libraryEntry.title = details!.title
//                        self.mangaEntry.title = details!.title
//                        self.mangaEntry.image = details!.image
//                        self.mangaEntry.id = details!.id
//                        self.mangaEntry.sourceId = details!.sourceId
//                        self.mangaEntry.libraryEntry = self.libraryEntry
//                    }
//                    return
//                }
//            }
//            else {
//                let source = SourceManager.shared.getSourceFromId(sourceId: mangaTile.sourceId)
//                let service = SourceAPIManager(sourceId: mangaTile.sourceId)
//                let result = try? await service.sourceAPI.getMangaDetails(source: source, mangaId: mangaTile.mangaId)
//                
//                DispatchQueue.main.async {
//                    
//                    self.mangaDetails = result
//                    self.mangaDetailsObservable.value = result
//                }
//            }
//        }
//    }
//    
//    /// Remove a library object from core data store
//    func remove(_ object: NSManagedObject) throws {
//        self.context.delete(object)
//        try self.save()
//    }
//}
