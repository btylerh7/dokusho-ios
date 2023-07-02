//
//  MangaTile.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/2/23.
//

import Foundation
import SwiftUI

struct MangaTile: Codable, Hashable, Identifiable {
    var id: String {
        self.sourceId
    }
    let sourceId: String
    let mangaId: String
    let title: String
    let image: String
}


