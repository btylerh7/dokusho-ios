//
//  MonogataryHomepageResults.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/25/23.
//

import Foundation

public class MonogataryHomepageResults: Codable {
    var currentPage: Int? = 1
    var pagesCount: Int? = 0
    let storiesList: [MonogataryAPIStoryTile]
    
}
