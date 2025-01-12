//
//  AllCollections.swift
//  Dokusho
//
//  Created by Tyler Baker on 8/1/23.
//

import Foundation

public struct AllCollections: Codable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [Collection]
    let number: Int
    let sort: Sort?
    let first: Bool?
    let numberOfElements: Int?
    let pageable: Pageable?
    let last: Bool?
    let empty: Bool?
}

public struct Collection: Codable {
    let id: String
    let name: String
    let ordered: Bool
    let seriesIds: [String]
    let createdDate: String
    let lastModifiedDate: String
    let filtered: Bool
}

