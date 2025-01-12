//
//  ReadProgress.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import Foundation
import Observation

@Observable
public class ReadProgress: Codable {
    var page: Int = 0
    var completed: Bool = false
    var readDate: String = ""
    var created: String = ""
    var lastModified: String = ""
    var deviceId: String = ""
    var deviceName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case _page = "page"
        case _completed = "completed"
        case _readDate = "readDate"
        case _created = "created"
        case _lastModified = "lastModified"
        case _deviceId = "deviceId"
        case _deviceName = "deviceName"
        case _$observationRegistrar
    }
}
