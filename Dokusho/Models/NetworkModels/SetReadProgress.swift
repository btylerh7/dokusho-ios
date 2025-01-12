//
//  SetReadProgress.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog

public class SetReadProgress: Endpoint {
    public typealias T = ReadProgress
    public var urlPath: String
    public var returnType = ReadProgress.self
    public var requestMethod: RequestMethod = .patch
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init (_ bookId: String, page: Int, total: Int) {
        let completed = page == total
        self.requestBody = [
            "page": page,
            "completed": completed
        ]
        self.urlPath = "/books/\(bookId)/read-progress"
    }
}
