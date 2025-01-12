//
//  MangaTile.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/2/23.
//

import Foundation
import SwiftUI

public struct MangaTile: Codable, Hashable, Identifiable {
    public var id: String {
        self.sourceId
    }
    let sourceId: String
    let mangaId: String
    let title: String
    let image: String
}


