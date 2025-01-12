//
//  LiveTextImageView.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/18/24.
//

import Foundation
import UIKit
import SwiftUI
import VisionKit
import OSLog

@MainActor
struct LiveTextUIImageView: UIViewRepresentable {
    var image: UIImage
    var analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    let imageView = ResizableImageView()
    
    func makeUIView(context: Context) -> UIImageView {
        imageView.image = image
        imageView.addInteraction(interaction)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        Task {
            do {
                let configuration = ImageAnalyzer.Configuration([.text])
//                guard let image = self.image else {
//                    Logger.liveTextLogger.error("Live text view does not have an image")
//                    return
//                }
                let analysis = try await analyzer.analyze(image, configuration: configuration)
                interaction.analysis = analysis
                interaction.preferredInteractionTypes = .textSelection
                    
            } catch {
                Logger.liveTextLogger.error("Error analyzing image: \(error.localizedDescription)")
            }
            
        }
    }
    
}

class ResizableImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
