//
//  LazyImageView2.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/16/24.
//

import SwiftUI
import NukeUI
import OSLog

struct LazyImageView2: View {
    var imageUrl: String
    var canShowLiveText = false
    @Binding var imageToScan: UIImage
    @State var showingLiveTextView: Bool = false
    @Binding var scanLiveText: Bool
    @Binding var scanCropImage: Bool
    @State var shouldScan = false
    @State var image: Image? = nil
    @State var cropImage: UIImage = UIImage()
    var body: some View {
        VStack {
            LazyImage(url: URL(string: imageUrl)) { state in
                if state.isLoading {ProgressView()}
                if state.image != nil {
                    state.image!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onAppear {
                            self.image = state.image
                        }
                        .onChange(of: self.scanLiveText, { oldValue, newValue in
                            if newValue == true {
                                self.createLiveTextImage(image: state.image!)
                            }
                        })
                        .onLongPressGesture(perform: {
                            if self.canShowLiveText == true {
                                let uiImage = state.image!.asUIImage()
                                self.imageToScan = uiImage
                                self.showingLiveTextView = true
                            }
                        })
                        .sheet(isPresented: $showingLiveTextView) {
                            self.scanLiveText = false
                            self.scanCropImage = false
                        } content: {
                                LiveTextUIImageView(image: imageToScan)
                        }
                        .sheet(isPresented: $scanCropImage) {
                            if shouldScan == true {
                                self.createLiveTextFromUIImage(image: self.cropImage)
                                self.scanCropImage = false
                            }
                        } content: {
                            CropImageViewControllerRepresentable(scannedImage: $cropImage, shouldScan: $shouldScan, image: imageToScan)
                        }

                }
                
            }
        }
    }
}
extension LazyImageView2 {
    
    func createUIImage(image: Image) async {
        let renderedImage = ImageRenderer(content: image)
        if let uiImage = renderedImage.uiImage {
            Logger.lazyImageLogger.info("Live text image created")
            self.cropImage = uiImage
        } else {
            Logger.lazyImageLogger.error("Failed to render image for live text analysis")
        }

    }
    func createLiveTextFromUIImage(image: UIImage) {
        Logger.lazyImageLogger.info("Live text image created")
        self.imageToScan = image
        self.showingLiveTextView = true
    }
    func createLiveTextImage(image: Image) {
        Logger.lazyImageLogger.info("Rendering image for live text analysis")
//        let renderedImage = ImageRenderer(content: image)
//        if let uiImage = renderedImage.uiImage {
//            Logger.lazyImageLogger.info("Live text image created")
//            self.imageToScan = uiImage
//            self.showingLiveTextView = true
//        } else {
//            Logger.lazyImageLogger.error("Failed to render image for live text analysis")
//        }
        
    }
}

//#Preview {
//    LazyImageView2()
//}
