//
//  Books.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation
import Observation

@Observable
public class Books: Codable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    var content: [Book]
    let number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let pageable: Pageable
    let last: Bool
    let empty: Bool
}








