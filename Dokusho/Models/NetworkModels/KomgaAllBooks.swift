//
//  KomgaAllBooks.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog

public struct AllBooks: Codable {
    var content: [Book]
}

public class KomgaAllBooks: Endpoint {
    public typealias T = AllBooks
    public var urlPath: String
    public var returnType = AllBooks.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init (seriesId: String) {
        self.urlPath = "/series/\(seriesId)/books"
    }
}
