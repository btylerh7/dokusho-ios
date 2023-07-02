//
//  Source.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/14/23.
//

import Foundation

struct Source: Codable, Hashable {
    let sourceId: String
    let sourceTitle: String
    let baseUrl: String
    let lang: String
    var webtoon: Bool = false
    var sourceType: String
}
