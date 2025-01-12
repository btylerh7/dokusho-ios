//
//  AllSeries.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

public struct AllSeries: Codable {
    let content: [Series]
    let pageable: Pageable
    let totalElements: Int
    let last: Bool
    let totalPages: Int
    let size: Int
    let number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

public struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

public struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
