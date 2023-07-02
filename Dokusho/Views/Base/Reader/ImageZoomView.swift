//
//  ImageZoomView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/19/23.
//

import SwiftUI
import NukeUI

struct ImageZoomView: View {
    let testUrl = URL(string: "https://kumacdn.club/wp-content/uploads/O/Oshi%20no%20Ko/Chapter%2001/001.jpg")
    let testUrl2 = URL(string: "https://kumacdn.club/wp-content/uploads/O/Oshi%20no%20Ko/Chapter%2001/002.jpg")
    
    let imageUrl: String
    @State var isZoomed = false
    @State var scale = 1.0
    @State var currentPosition: CGSize = .zero
    @State var newPosition: CGSize = .zero
    @State var isPresentingScannedTextView = false
    @State var isShowingCropView = false
    @State var scannedText = ""
    @State var imageToScan = UIImage()
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                LazyImage(url: URL(string: imageUrl)) { state in
                    if state.isLoading {ProgressView()}
                    if state.image != nil {
                        state.image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(x: currentPosition.width, y: currentPosition.height)
                            .gesture(
                                TapGesture(count: 2)
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
                            )
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
        .onChange(of: scannedText, perform: { newValue in
            isPresentingScannedTextView = true
        })
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

extension ImageZoomView {
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

struct ImageZoomView_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.dismiss) var dismiss
        @State var hidden = false
        NavigationStack {
            TabView {
                ImageZoomView(imageUrl: "https://kumacdn.club/wp-content/uploads/O/Oshi%20no%20Ko/Chapter%2001/001.jpg")
                    .tag(0)
                ImageZoomView(imageUrl: "https://kumacdn.club/wp-content/uploads/O/Oshi%20no%20Ko/Chapter%2001/001.jpg")
                    .tag(1)
            }
            
            .toolbar {
                if hidden == false {
                    ToolbarItem(placement:.navigationBarLeading) {
                        Image(systemName: "x.circle.fill")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle(hidden ? "" : "Chapter 1")
            .navigationBarTitleDisplayMode(.inline)
            .tabViewStyle(PageTabViewStyle())

        }
    }
}
