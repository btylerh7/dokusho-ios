//
//  Endpoint.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation

public enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}
public enum ApiVersion: String {
    case v1
    case v2
}
public protocol Endpoint<T> {
    associatedtype T: Codable
    var urlPath: String { get set }
    var returnType: T.Type { get set }
    var requestMethod: RequestMethod { get set }
    var requestBody: [String:Any]? { get set }
    var apiVersion: String { get set }
}
