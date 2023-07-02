//
//  ChapterObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
//

import Foundation
import CoreData

@objc(ChapterObject)
public class ChapterObject: NSManagedObject {

}

extension ChapterObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChapterObject> {
        return NSFetchRequest<ChapterObject>(entityName: "ChapterEntry")
    }

    @NSManaged public var chapter: Float
    @NSManaged public var id: String?
    @NSManaged public var lang: String?
    @NSManaged public var mangaId: String?
    @NSManaged public var sourceId: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var manga: MangaObject?
    @NSManaged public var history: HistoryObject?

}

extension ChapterObject : Identifiable {

}

