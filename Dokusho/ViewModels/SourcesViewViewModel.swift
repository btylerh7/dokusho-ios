//
//  SourcesViewViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/30/23.
//

import Foundation

final class SourcesViewViewModel {
    
    var sources = SourceManager.shared.getAllSources()
    
    func updateSources() {
        sources = SourceManager.shared.getAllSources()
    }
}
