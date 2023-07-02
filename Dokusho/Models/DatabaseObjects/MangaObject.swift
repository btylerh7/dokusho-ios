//
//  MangaObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
//

import Foundation
import CoreData

@objc(MangaObject)
public class MangaObject: NSManagedObject {

}

extension MangaObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MangaObject> {
        return NSFetchRequest<MangaObject>(entityName: "MangaEntry")
    }

    @NSManaged public var author: String?
    @NSManaged public var chapterCount: Int64
    @NSManaged public var image: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var sourceId: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var libraryEntry: LibraryEntryObject?
    @NSManaged public var history: NSSet?
    @NSManaged public var chapters: NSSet?
    
    
    
    public var historyArray: [HistoryObject] {
        let set = history as? Set<HistoryObject> ?? []
        return Array(set)
    }

}

// MARK: Generated accessors for chapters
extension MangaObject {

    @objc(addChaptersObject:)
    @NSManaged public func addToChapters(_ value: ChapterObject)

    @objc(removeChaptersObject:)
    @NSManaged public func removeFromChapters(_ value: ChapterObject)

    @objc(addChapters:)
    @NSManaged public func addToChapters(_ values: NSSet)

    @objc(removeChapters:)
    @NSManaged public func removeFromChapters(_ values: NSSet)
    
    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: HistoryObject)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: HistoryObject)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

extension MangaObject : Identifiable {

}

