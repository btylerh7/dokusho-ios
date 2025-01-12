//
//  GetReadProgress.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog

public class GetReadProgress: Endpoint {
    public typealias T = ReadProgress
    public var urlPath: String
    public var returnType = ReadProgress.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init (_ bookId: String) {
        self.urlPath = "/books/\(bookId)"
    }
}
