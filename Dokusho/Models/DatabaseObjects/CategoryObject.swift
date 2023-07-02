//
//  CategoryObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/18/23.
//

import Foundation
import CoreData

@objc(CategoryObject)
public class CategoryObject: NSManagedObject {
    
}

extension CategoryObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryObject> {
        return NSFetchRequest<CategoryObject>(entityName: "CategoryEntry")
    }


    @NSManaged public var categoryId: String?
    @NSManaged public var title: String?
    @NSManaged public var libraryEntries: NSSet?
    
    public var entryArray: [LibraryEntryObject] {
        let set = libraryEntries as? Set<LibraryEntryObject> ?? []
        return Array(set)
    }
    
    static func all() -> NSFetchRequest<CategoryObject> {
        let request:NSFetchRequest<CategoryObject> = self.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CategoryObject.title, ascending: true)
        ]
        return request
    }
}

// MARK: Generated accessors for bookmarkList
extension CategoryObject {

    @objc(addLibraryEntryObject:)
    @NSManaged public func addToLibraryEntries(_ value: LibraryEntryObject)

    @objc(removeLibraryEntryObject:)
    @NSManaged public func removeFromLibraryEntries(_ value: LibraryEntryObject)


}

extension CategoryObject : Identifiable {

}

