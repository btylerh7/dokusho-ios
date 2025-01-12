//
//  Router.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import Foundation
import Observation
import SwiftUI

public enum RouterDestination: Hashable {
    case series(series: Series)
    case mangaTile(tile: MangaTile)
    case category(category: CategoryItem)
}
public enum SheetDestination: Hashable, Identifiable {
    public static func == (lhs: SheetDestination, rhs: SheetDestination) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public var id: String {
        switch self {
        case .liveTextView(let imageToScan):
            "liveText"
        case .addCategoryModal:
            "addCategory"
        case .addToCategoryModal(let mangaId, let sourceId):
            "addToCategory"
        case .scannedTextView(let text):
            "scannedText"
        case .reader(let book):
            "reader"
        }
    }
    
    case liveTextView(imageToScan: UIImage)
    case addCategoryModal
    case addToCategoryModal(mangaId: String, sourceId: String)
    case scannedTextView(text: String)
    case reader(book: Book)
    
}

@MainActor
@Observable
public class RouterPath {
    
    public var path: [RouterDestination] = []
    // May add this, not sure
//    public var presentedSheet: SheetDestination?
    
    
    public init() {}
    
    public func navigate(to: RouterDestination) {
        path.append(to)
    }
    public func popToRoot() {
        path.removeAll()
    }
}
