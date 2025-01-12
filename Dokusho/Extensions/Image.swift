//
//  Image.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import Foundation
import SwiftUI
import UIKit
import OSLog

extension View {
    @MainActor
    func asUIImage() -> UIImage {
        let image = ImageRenderer(content: self)
        guard let uiImage = image.uiImage else {
            Logger.liveTextLogger.error("No UIImage Found")
            return UIImage()
        }
        return uiImage
    }
}
