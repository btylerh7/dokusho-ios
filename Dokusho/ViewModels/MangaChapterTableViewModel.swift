//
//  MangaChapterTableViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 4/1/23.
//

import Foundation
import CoreData

struct ChapterIterator: Hashable {
    let chapter: Chapter
    let read: Bool
    let progress: Int16?
    let total: Int16?
}

final public class MangaChapterTableViewModel {
    
    var mangaDetails: MangaDetails? = nil
    var mangaId: String
    var mangaDetailsObservable: ObservableItem<MangaDetails?> = ObservableItem(nil)
    var context: NSManagedObjectContext
    //    var libraryEntry: LibraryEntryObject? = nil
    //    var mangaEntry: MangaObject? = nil
    var source: Source? = nil
    var chapters: [Chapter] = []
    var chaptersObservable: ObservableItem<[Chapter]?> = ObservableItem(nil)
    var chapterIterators: [ChapterIterator] = []
    var chapterIteratorObservable: ObservableItem<[ChapterIterator]> = ObservableItem([])
    
    //libraryEntry: LibraryEntryObject? = nil, mangaEntry: MangaObject? = nil
    init(provider: CoreDataManager, mangaId: String) {
        self.context = provider.newContext
        self.mangaId = mangaId
    }
    
    //    func setUpCoreDataObjects() {
    //        context.performAndWait {
    //            self.libraryEntry = LibraryEntryObject(context: self.context)
    //            self.mangaEntry = MangaObject(context: self.context)
    //        }
    //    }
    /// Save core data context if there are changes.
    public func save() {
        context.performAndWait {
            if context.hasChanges {
                try? context.save()
            }
        }
    }
    
    func getMangaChapters(manga: MangaTile, source: Source) {
        Task {
            let service = SourceAPIManager(sourceId: source.sourceId)
            let results = try? await service.sourceAPI.getMangaChapters(source: source, mangaId: manga.mangaId)
            DispatchQueue.main.async {
                self.chapters = results ?? []
                self.chaptersObservable.value = results ?? []
            }
        }
    }
    
    func createChapterIteratorV2() {
        context.perform {
            self.chapterIterators = []
            let hasSource = CoreDataManager.shared.hasLibraryObject(id: self.mangaId, sourceId: self.source!.sourceId, context: self.context) // TODO: Check this. Should it use the new context?
            if hasSource != true {
                for chapter in self.chapters {
                    let iterator = ChapterIterator(chapter: chapter, read: false, progress: nil, total: nil)
                    self.chapterIterators.append(iterator)
                }
            }
            for chapter in self.chapters {
                if let history = CoreDataManager.shared.getHistoryForChapter(chapter: chapter, source: self.source!, context: self.context) {
                    print("Chapter \(chapter.chapNum) was last on page \(history.progress) of \(history.total)")
                    let iterator = ChapterIterator(chapter: chapter, read: true, progress: Int16(history.progress), total: Int16(history.total))
                    self.chapterIterators.append(iterator)
                }
                else {
                    let iterator = ChapterIterator(chapter: chapter, read: false, progress: nil, total: nil)
                    self.chapterIterators.append(iterator)
                }
                
            }
            print("done")
            self.chapterIteratorObservable.value = self.chapterIterators
        }
        
    }
    
    
    // MARK: MangaDetails
    
    /// Checks if there is a manga stored in database and uses that. If there is no database entry, then it will load from the internet.
    public func getMangaDetailsV1(sourceId: String, mangaId: String) async {
        await context.perform {
//            let hasSource = CoreDataManager.shared.hasLibraryObject(id: mangaId,sourceId: sourceId, context: self.context)
//            if hasSource == true {
            if let details = CoreDataManager.shared.getMangaFromId(mangaId: mangaId, sourceId: sourceId, context:self.context){
                    DispatchQueue.main.async {
                        self.mangaDetailsObservable.value = CoreDataManager.shared.createMangaDetails(mangaEntry: details, context: self.context)
                  //                        self.libraryEntry?.image = details!.image
                  //                        self.libraryEntry?.mangaId = details!.id
                  //                        self.libraryEntry?.title = details!.title
                  //                        self.mangaEntry?.title = details!.title
                  //                        self.mangaEntry?.image = details!.image
                  //                        self.mangaEntry?.id = details!.id
                  //                        self.mangaEntry?.sourceId = details!.sourceId
                  //                        self.mangaEntry?.libraryEntry = self.libraryEntry
                  //                        self.readChapters = details!.historyArray
                  //                        print("history array: \(String(describing: self.readChapters))")
              }
                return
            }
        }
        let service = SourceAPIManager(sourceId: sourceId)
        self.source = SourceManager.shared.getSourceFromId(sourceId: sourceId)
        if self.source != nil {
            Task {
                let details = try await service.sourceAPI.getMangaDetails(source: self.source! , mangaId: mangaId)
                DispatchQueue.main.async {
                    self.mangaDetailsObservable.value = details
                }
                //                    self.libraryEntry?.image = details.image
                //                    self.libraryEntry?.mangaId = details.mangaId
                //                    self.libraryEntry?.title = details.title
                //                    self.mangaEntry?.title = details.title
                //                    self.mangaEntry?.image = details.image
                //                    self.mangaEntry?.id = details.mangaId
                //                    self.mangaEntry?.sourceId = sourceId
                //                    self.mangaEntry?.libraryEntry = self.libraryEntry
            }
        }
    }
//
//    /// Checks if there is a manga stored in database and uses that. If there is no database entry, then it will load from the internet.
//    public func getMangaDetailsV2(sourceId: String, mangaId: String) async {
//        do {
//            Task {
//                if let details = CoreDataManager.shared.getMangaFromId(mangaId: mangaId, sourceId: sourceId, context: self.context) {
//                        DispatchQueue.main.async {
//                            self.mangaDetails = CoreDataManager.shared.createMangaDetails(mangaEntry: details, context: self.context)
//                            self.mangaDetailsObservable.value = self.mangaDetails
//
//                        }
//                    }
//                    else {
//                        let service = SourceAPIManager(sourceId: sourceId)
//                        self.source = SourceManager.shared.getSourceFromId(sourceId: sourceId)
//                        if self.source != nil {
//                            let details = try await service.sourceAPI.getMangaDetails(source: self.source! , mangaId: mangaId)
//                            DispatchQueue.main.async {
//                                self.mangaDetails = details
//                                self.mangaDetailsObservable.value = details
//                            }
//
//
//                            //                        self.libraryEntry?.image = details.image
//                            //                        self.libraryEntry?.mangaId = details.mangaId
//                            //                        self.libraryEntry?.title = details.title
//                            //
//                            //                        self.mangaEntry?.title = details.title
//                            //                        self.mangaEntry?.image = details.image
//                            //                        self.mangaEntry?.id = details.mangaId
//                            //                        self.mangaEntry?.sourceId = sourceId
//                            //                        self.mangaEntry?.libraryEntry = self.libraryEntry
//
//                        }
//                    }
//                }
//                self.mangaDetailsObservable.bind { details in
//
//                    DispatchQueue.main.async {
//                        if let libraryEntry = self.libraryEntry {
//                            libraryEntry.image = details!.image
//                            libraryEntry.mangaId = details!.mangaId
//                            libraryEntry.title = details!.title
//                        } else {
//                            self.libraryEntry = LibraryEntryObject(context: self.context)
//                            self.libraryEntry?.image = details!.image
//                            self.libraryEntry?.mangaId = details!.mangaId
//                            self.libraryEntry?.title = details!.title
//                        }
//
//                        if let mangaEntry = self.mangaEntry {
//                            mangaEntry.title = details!.title
//                            mangaEntry.image = details!.image
//                            mangaEntry.id = details!.mangaId
//                            mangaEntry.sourceId = details!.sourceId
//                            mangaEntry.libraryEntry = self.libraryEntry
//                        } else {
//                            self.mangaEntry?.title = details!.title
//                            self.mangaEntry?.image = details!.image
//                            self.mangaEntry?.id = details!.mangaId
//                            self.mangaEntry?.sourceId = details!.sourceId
//                            self.mangaEntry?.libraryEntry = self.libraryEntry
//                        }
//                    }
//                }
//            save() // Save changes to Core Data context
//        }
//        catch {
//            print("error getting details: \(error)")
//        }
//    }
//
    
}
