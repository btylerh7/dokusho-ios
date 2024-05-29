//
//  SourceManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/17/23.
//

import Foundation
import CoreData

final public class SourceManager {
    static let shared = SourceManager()
    var sources: [Source] = [
        Source(sourceId: "rawkuma", sourceTitle: "Rawkuma", baseUrl: "https://rawkuma.com", lang: "ja", sourceType: "image"),
        Source(sourceId: "monogatary", sourceTitle: "Monogatary", baseUrl: "https://monogatary.com", lang: "ja", sourceType: "text"),
        Source(sourceId: "komga", sourceTitle: "Komga", baseUrl: UserDefaults.standard.object(forKey: "komga-server-address") as? String ?? "", lang: "ja", sourceType: "image")
        
    ]
    func getAllSources() -> [Source] {

        checkForKomga()
        return sources
    }
    func checkForKomga() {
        guard let komgaServerAddress = UserDefaults.standard.object(forKey: "komga-server-address") as? String else {
            sources.removeLast()
            return
        }
        
    }
    func getSourceFromId(sourceId: String) -> Source {
        let filtered = sources.filter { source in
            return source.sourceId == sourceId
        }
        return filtered[0]
    }
}
