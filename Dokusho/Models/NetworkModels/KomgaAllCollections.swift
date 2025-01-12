//
//  KomgaAllCollections.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog

public class KomgaAllCollections: Endpoint {
    public typealias T = AllCollections
    public var urlPath: String = "/collections"
    public var returnType = AllCollections.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
}
