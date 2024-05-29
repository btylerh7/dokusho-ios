//
//  KomgaImageView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import NukeUI

struct KomgaImageView: View {
    @Binding var scannedText: String
    @State var bookId: String
    @State var page: Int
    @State var url: URL? = nil

    @State var isZoomed = false
    @State var scale = 1.0
    @State var currentPosition: CGSize = .zero
    @State var newPosition: CGSize = .zero
    @State var isPresentingScannedTextView = false
    @State var isShowingCropView = false
    
    @State var imageToScan = UIImage()
    @State var isDisplayingOverlay = true
    
    var body: some View {
        let tapGesture = TapGesture(count: 2)
            .onEnded({ _ in
                withAnimation {
                    isZoomed = !isZoomed
                    scale = isZoomed ? 2.0 : 1.0
                    if !isZoomed {
                        currentPosition = .zero
                        newPosition = .zero
                    }
                }
            })
        
        VStack {
            GeometryReader { geo in
                LazyImage(url: url) { state in
                    if state.isLoading {ProgressView()}
                    if state.image != nil {
                        state.image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(x: currentPosition.width, y: currentPosition.height)
                            .gesture(tapGesture)
                            .gesture(
                                LongPressGesture(minimumDuration: 1.5)
                                    .onChanged({ _ in
                                        let cgImage = ImageRenderer(content: state.image!).cgImage!
                                        self.imageToScan = UIImage(cgImage: cgImage)
                                        self.isShowingCropView = true
                                    })
                            )
                            .highPriorityGesture(
                                isZoomed ?
                                DragGesture()
                                    .onChanged({ value in
                                        let updatedWidth = value.translation.width * 1.33 + self.newPosition.width
                                        let updatedHeight = value.translation.height * 1.33 + self.newPosition.height
                                        if isZoomed {
                                            self.currentPosition = CGSize(width: updatedWidth, height: updatedHeight)
                                        }
                                    })
                                    .onEnded { value in
                                        let updatedWidth = value.translation.width * 1.33
                                        let updatedHeight = value.translation.height * 1.33
                                        let updatedSize = CGSize(width: updatedWidth, height: updatedHeight)
                                        checkWidthAndHeight(value: updatedSize, geo: geo.size)
                                    }
                                : nil
                            )
                        
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height - 30)
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $isShowingCropView) {
            CropImageViewControllerRepresentable(scannedText: $scannedText, image: imageToScan)
        }
        .task {
            await makeUrl()
        }
        .sheet(isPresented: $isPresentingScannedTextView) {
            VStack(spacing: 10) {
                
                Text("Scanned Text:")
                    .font(.title)
                Text(scannedText)
                    .textSelection(.enabled)
                Spacer()
            }
            .padding()
        }
        
        
    }
}

extension KomgaImageView {
    func checkWidthAndHeight(value: CGSize, geo: CGSize) {
        var updatedWidth = value.width + self.newPosition.width
        var updatedHeight = value.height + self.newPosition.height
        
        if isZoomed {
            let absWidth = abs(updatedWidth)
            let imageWidth = geo.width/2
            let absHeight = abs(updatedHeight)
            let imageHeight = (geo.height - 30)/2
            if absWidth > imageWidth {
                updatedWidth = updatedWidth > 0 ? imageWidth : -imageWidth
            }
            if absHeight > imageHeight {
                updatedHeight = updatedHeight > 0 ? imageHeight : -imageHeight
            }
            
            withAnimation {
                self.currentPosition = CGSize(width: updatedWidth, height: updatedHeight)
                self.newPosition = self.currentPosition
            }
        }
    }
}

extension KomgaImageView {
    func makeUrl() async {
        guard let urlString = Komgav2APIService.shared.getBookPageUrl(bookId: bookId, page: page) else {return}
        self.url = URL(string: urlString)
    }
}


//struct KomgaImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaImageView()
//    }
//}
