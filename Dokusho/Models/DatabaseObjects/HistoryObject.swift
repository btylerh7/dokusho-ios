//
//  HistoryObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
//

import Foundation
import CoreData

@objc(HistoryObject)
final public class HistoryObject: NSManagedObject {

}

extension HistoryObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryObject> {
        return NSFetchRequest<HistoryObject>(entityName: "HistoryEntry")
    }

    @NSManaged public var total: Int16
    @NSManaged public var sourceId: String?
    @NSManaged public var mangaId: String?
    @NSManaged public var completed: Bool
    @NSManaged public var progress: Int16
    @NSManaged public var chapterId: String?
    @NSManaged public var chapter: ChapterObject?
    @NSManaged public var manga: MangaObject?

}

extension HistoryObject : Identifiable {

}

