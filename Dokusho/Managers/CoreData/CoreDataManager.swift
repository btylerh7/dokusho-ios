//
//  CoreDataManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/15/23.
//

import Foundation
import CoreData


final public class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init (){
        persistentContainer = NSPersistentContainer(name: "DokushoDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print("CoreDataManager.save: \(error.localizedDescription)")
        }
    }

    func saveIfNeeded() {
        if viewContext.hasChanges {
            save()
        }
    }

    func remove(_ object: NSManagedObject) {
        persistentContainer.performBackgroundTask { context in
            let object = context.object(with: object.objectID)
            context.delete(object)
            try? context.save()
            print("removed!")
        }
    }
    
    /// Clear all objects from fetch request.
        func clear<T: NSManagedObject>(request: NSFetchRequest<T>, context: NSManagedObjectContext? = nil) {
            let context = context ?? self.viewContext
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: (request as? NSFetchRequest<NSFetchRequestResult>)!)
            do {
                _ = try context.execute(deleteRequest)
            } catch {
                print("CoreDataManager.clear: \(error.localizedDescription)")
            }
        }
}
