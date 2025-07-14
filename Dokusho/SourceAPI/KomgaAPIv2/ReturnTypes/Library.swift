//
//  Library.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/13/25.
//

import Foundation
import Observation

@Observable
public class Library: Codable, Identifiable {
    public static func == (lhs: Library, rhs: Library) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String
    let name: String
    let root: String
}
