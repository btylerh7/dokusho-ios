//
//  CoreDataManager+Category.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/18/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    func addToCategories(context: NSManagedObjectContext? = nil, text: String) {
        let context = context ?? self.viewContext
        let categoryEntry = CategoryObject(context: context)
        categoryEntry.categoryId = text
        categoryEntry.title = text
        categoryEntry.libraryEntries = NSSet()
        try? context.save()
    }
    func getCategories(context: NSManagedObjectContext? = nil) -> [CategoryObject] {
        let context = context ?? CoreDataManager.shared.viewContext
        let request = CategoryObject.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    func getLibraryEntriesInCategory(categoryId: String, context: NSManagedObjectContext? = nil) -> [LibraryEntryObject] {
        
        let context = context ?? CoreDataManager.shared.viewContext
        var entries: [LibraryEntryObject] = []
        
        print("category is: \(categoryId)")
        
        if categoryId != "All" {
            let request = CategoryObject.fetchRequest()
            request.predicate = NSPredicate(format: "categoryId == %@", categoryId)
            let category = (try? context.fetch(request)) ?? []
            if let returnedEntries = category.first?.entryArray {
                for entry in returnedEntries {
                    entries.append(entry)
                }
            }
        }
        else {
            let request = LibraryEntryObject.fetchRequest()
            let returnedEntries = (try? context.fetch(request)) ?? []
            for returnedEntry in returnedEntries {
                entries.append(returnedEntry)
            }
        }
        
        
        return entries
    }
    
//    func getCategoriesForManga(libraryEntry: LibraryEntryObject, context: NSManagedObjectContext? = nil) -> [CategoryObject] {
//        let context = context ?? CoreDataManager.shared.viewContext
//        let request = CategoryObject.fetchRequest()
//        request.predicate = NSPredicate(format: "manga == %@", libraryEntry)
//        return (try? context.fetch(request)) ?? []
//    }
}
