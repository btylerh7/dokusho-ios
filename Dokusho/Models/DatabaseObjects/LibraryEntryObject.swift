//
//  LibraryEntryObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
//

import Foundation
import CoreData

@objc(LibraryEntryObject)
public class LibraryEntryObject: NSManagedObject {
    
}

extension LibraryEntryObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LibraryEntryObject> {
        return NSFetchRequest<LibraryEntryObject>(entityName: "LibraryEntry")
    }

    @NSManaged public var image: String?
    @NSManaged public var mangaId: String?
    @NSManaged public var title: String?
    @NSManaged public var bookmarkList: NSSet?
    @NSManaged public var manga: MangaObject?
    @NSManaged public var sourceId: String
    @NSManaged public var categories: NSSet?
    
    public var categoriesArray: [CategoryObject] {
        let set = categories as? Set<CategoryObject> ?? []
        return Array(set)
    }

}

// MARK: Generated accessors for bookmarkList
extension LibraryEntryObject {

//    @objc(addBookmarkListObject:)
//    @NSManaged public func addToBookmarkList(_ value: BoookmarkListObject)
//
//    @objc(removeBookmarkListObject:)
//    @NSManaged public func removeFromBookmarkList(_ value: BoookmarkListObject)

    @objc(addBookmarkList:)
    @NSManaged public func addToBookmarkList(_ values: NSSet)

    @objc(removeBookmarkList:)
    @NSManaged public func removeFromBookmarkList(_ values: NSSet)
    
    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: CategoryObject)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: CategoryObject)

}

extension LibraryEntryObject : Identifiable {

}
