//
//  LibraryEntry.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/11/23.
//

import Foundation
import CoreData


extension LibraryEntryObject {
    
    private static var libraryFetchRequest: NSFetchRequest<LibraryEntryObject> {
        NSFetchRequest(entityName: "LibraryEntry")
    }
    
    static func all() -> NSFetchRequest<LibraryEntryObject> {
        let request:NSFetchRequest<LibraryEntryObject> = libraryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \LibraryEntryObject.title, ascending: true)
        ]
        return request
    }
    
    static func filter(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", query)
    }
    
    static func single(_ query: String) -> NSFetchRequest<LibraryEntryObject> {
        let request:NSFetchRequest<LibraryEntryObject> = libraryFetchRequest
        request.predicate = NSPredicate(format: "mangaId == %@", query)
        request.fetchLimit = 1
        return request
        
    }
//    static func hasSource(id: String, context: NSManagedObjectContext? = nil) -> Bool {
//        let context = context ?? self.vie
//            let request = LibraryEntryObject.fetchRequest()
//            request.predicate = NSPredicate(format: "mangaId == %@", id)
//            request.fetchLimit = 1
//            return (try? context.count(for: request)) ?? 0 > 0
//    }
    
    static func deleteEntry(id: String, context: NSManagedObjectContext) {
        let request = self.single(id)
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    

}
