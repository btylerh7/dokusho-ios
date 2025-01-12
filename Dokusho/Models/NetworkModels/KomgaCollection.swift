//
//  KomgaCollection.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/20/24.
//

import Foundation
import OSLog

public class KomgaCollection: Endpoint {
    public typealias T = Collection
    public var urlPath: String
    public var returnType = Collection.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init (_ collectionId: String) {
        self.urlPath = "/collections/\(collectionId)"
    }
}
