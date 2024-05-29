//
//  ReadProgress.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation

struct ReadProgress: Codable {
    let page: Int
    let completed: Bool
    let readDate: String
    let created: String
    let lastModified: String
}
