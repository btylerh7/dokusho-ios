//
//  CoreDataManager+Source.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/17/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    func createSourceFromEntry(sourceEntry: SourceObject)-> Source? {
        guard case _ = sourceEntry.baseUrl != nil, sourceEntry.title != nil, sourceEntry.id != nil else {
            return nil
        }
        let source = Source(sourceId: sourceEntry.id!, sourceTitle: sourceEntry.title!, baseUrl: sourceEntry.baseUrl!, lang: sourceEntry.lang ?? "en", sourceType: "image")
        return source
    }
    
    func getSources(context: NSManagedObjectContext? = nil) -> [SourceObject] {
        let viewContext = context ?? CoreDataManager.shared.viewContext
        let request = SourceObject.fetchRequest()
        
        return (try? viewContext.fetch(request)) ?? []
    }
}
