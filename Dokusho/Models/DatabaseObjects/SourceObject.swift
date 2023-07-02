//
//  SourceObject.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//
//

import Foundation
import CoreData

@objc(SourceObject)
public class SourceObject: NSManagedObject {

}
extension SourceObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceObject> {
        return NSFetchRequest<SourceObject>(entityName: "SourceEntry")
    }

    @NSManaged public var id: String?
    @NSManaged public var lang: String?
    @NSManaged public var title: String?
    @NSManaged public var baseUrl: String?

}

extension SourceObject : Identifiable {

}
