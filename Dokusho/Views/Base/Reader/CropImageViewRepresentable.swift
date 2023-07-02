//
//  CropImageViewRepresentable.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/20/23.
//

import Foundation
import UIKit
import SwiftUI
import CropViewController

struct CropImageViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var scannedText: String
    var image: UIImage
    
    func makeUIViewController(context: Context) -> UIViewController {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: CropImageViewControllerRepresentable
        
        init(_ cropViewController: CropImageViewControllerRepresentable) {
            self.parent = cropViewController
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            Task {
                await parent.detectText(image: image)
            }
            cropViewController.dismiss(animated: true)
        }
    }
}

extension CropImageViewControllerRepresentable {
    private func detectText(image:UIImage) async {
        let resultText = await OCRManager.shared.sendToApi(image: image)
        let cleanedText = OCRManager.shared.cleanOutput(resultText ?? "")
        DispatchQueue.main.async {
            self.scannedText = cleanedText
        }
    }
}
