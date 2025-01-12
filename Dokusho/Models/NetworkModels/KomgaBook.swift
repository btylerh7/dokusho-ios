//
//  KomgaBook.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog
public class KomgaBook: Endpoint {
    public typealias T = Book
    
    public var urlPath: String
    
    public var returnType: T.Type = Book.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init(id: String) {
        self.urlPath = "/books/\(id)"
    }
}
