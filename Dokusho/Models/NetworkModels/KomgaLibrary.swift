//
//  KomgaLibrary.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/13/25.
//

import Foundation
import OSLog

public class KomgaAllLibraries: Endpoint {
    public typealias T = [Library]
    public var urlPath: String
    public var returnType = [Library].self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init () {
        self.urlPath = "/libraries"
    }
}
