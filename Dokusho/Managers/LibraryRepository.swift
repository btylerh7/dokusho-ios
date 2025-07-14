//
//  LibraryRepository.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/28/25.
//

import SwiftData
import Foundation

public final class LibraryRepository {
    var series: [Series] = []
    var genres: [String] = []
    
    func getSeries(client: Client) async {
        guard let seriesList = await client.getAllSeries() else {return}
        let comics = seriesList.content.filter { series in
            series.booksCount > 0
        }
        
            
        
    }
}
