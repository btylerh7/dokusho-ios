//
//  Logger.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/18/24.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let mangaDetailView = Logger(subsystem: subsystem, category: "MangaDetailView")
    static let mangaReaderView = Logger(subsystem: subsystem, category: "MangaReaderView")
    static let clientLogger = Logger(subsystem: subsystem, category: "Client")
    static let liveTextLogger = Logger(subsystem: subsystem, category: "LiveTextView")
    static let lazyImageLogger = Logger(subsystem: subsystem, category: "LazyImageView")

}
