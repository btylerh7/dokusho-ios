//
//  KomgaAllSeries.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/19/24.
//

import Foundation
import OSLog

public class KomgaAllSeries: Endpoint {
    public typealias T = AllSeries
    public var urlPath: String = "/series/list?unpaged=true"
    public var returnType = AllSeries.self
    public var requestMethod: RequestMethod = .post
    public var apiVersion: String = "v1"
    public var requestBody: [String : Any]? = nil
}
