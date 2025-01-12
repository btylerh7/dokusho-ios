//
//  KomgaSeries.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//


import Foundation
import OSLog

public class KomgaSeries: Endpoint {
    public typealias T = Series
    public var urlPath: String
    public var returnType = Series.self
    public var requestMethod: RequestMethod = .get
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
    
    init (_ seriesId: String) {
        self.urlPath = "/series/\(seriesId)"
    }
}
