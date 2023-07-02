//
//  BrowseViewModel.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/30/23.
//

import Foundation
import UIKit

@MainActor
public class BrowseViewModel {
    
    var collectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
        
    }()
    
    let source: Source
    var tiles: [MangaTile]? = nil
    
    init(source: Source) {
        
        self.source = source
        self.tiles = nil
        getHomepageResults()
        
    }
    
    func getHomepageResults() {
        print("Starting to get results for homepage on \(source.sourceTitle)")
        Task {
            let service = SourceAPIManager(sourceId: self.source.sourceId)
            let results = try? await service.sourceAPI.getHomepageResults(source: self.source)
            if results != nil {
                DispatchQueue.main.async {
                    self.tiles = results
                    self.collectionView.reloadData()
                }
            }
        }
    }
}




