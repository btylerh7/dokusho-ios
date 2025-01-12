//
//  KomgaReaderView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import OSLog

struct KomgaReaderView: View {
    @Environment(NetworkManager.self) private var client
    @Bindable var book: Book
    @State var imageToScan: UIImage = UIImage()
    @State var showingCropImageView = false
    @State var showingLiveTextView = false
    @State var scanLiveText = false
    @State var scanCropImage = false
    @State var pages: [BookPage] = []
    @State var selectedPage: Int = 1 // I made it 1 indexed, yeah
    var opacity: Double {
        showingPageCount ? 1 : 0
    }
    @State var showingPageCount = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedPage) {
                    ForEach(createPages(), id:\.1) { (pageUrl, page) in
                        MediaUIZoomableContainer {
                            LazyImageView2(imageUrl: pageUrl, canShowLiveText: true, imageToScan: $imageToScan, showingLiveTextView: $showingLiveTextView, scanLiveText: $scanLiveText, scanCropImage: $scanCropImage)
                        }
                        .tag(page)
                    }
                }
                .scrollTargetLayout()
                .scrollTargetBehavior(.paging)
                .tabViewStyle(PageTabViewStyle())
                .environment(\.layoutDirection, .rightToLeft)
                .onTapGesture {
                    withAnimation {
                        showingPageCount.toggle()
                    }
                }
                .sheet(isPresented: $showingLiveTextView) {
                    self.scanLiveText = false
                    self.scanCropImage = false
                } content: {
                        LiveTextUIImageView(image: imageToScan)
                }
            }
            .task {
                guard let page = book.readProgress?.page else {return}
                self.selectedPage = page
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "x.circle")
                        .imageScale(.large)
                        .onTapGesture {
                            Task { await setReadingProgress() }
                        }
                        .padding(.leading, 20)
                        .opacity(opacity)
                        .disabled(opacity == 1 ? false : true)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "text.viewfinder")
                            .padding()
                            .opacity(opacity)
                            .disabled(opacity == 1 ? false : true)
                            .onTapGesture {
                                self.scanLiveText = true
                            }
                        Image(systemName: "text.below.photo")
                            .padding()
                            .opacity(opacity)
                            .disabled(opacity == 1 ? false : true)
                            .onTapGesture {
                                self.scanCropImage = true
                            }

                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(book.metadata.title)
                        .bold()
                        .opacity(opacity)
                }
                ToolbarItem(placement: .bottomBar) {
                    Text("Page \(selectedPage) of \(book.media.pagesCount)")
                        .opacity(opacity)
                }
            }
        }
    }
}

extension KomgaReaderView {
    func createLiveTextImage(image: Image) {
        Logger.lazyImageLogger.info("Rendering image for live text analysis")
        let renderedImage = ImageRenderer(content: image)
        if let uiImage = renderedImage.uiImage {
            Logger.lazyImageLogger.info("Live text image created")
            self.imageToScan = uiImage
            self.showingLiveTextView = true
        } else {
            Logger.lazyImageLogger.error("Failed to render image for live text analysis")
        }
    }
    func createPages() -> [(String, Int)] {
        var results:[(String, Int)]  = []
        for i in 1...book.media.pagesCount {
            let url = client.getBookPageUrl(bookId: book.id, page: i)
            results.append((url, i))
        }
        return results
    }
    func makeUrl(bookId: String, page: Int) async -> URL? {
        let urlString = client.getBookPageUrl(bookId: bookId, page: page)
        return URL(string: urlString)
    }
    func setReadingProgress() async {
        if let result = await client.setReadingProgress(bookId: book.id, page: selectedPage, total: book.media.pagesCount) {
            Logger.mangaReaderView.debug("Reading progress updated on Komga to \(result)")
            book.readProgress?.page = result
        } else {
            Logger.mangaReaderView.error("Could not set progress to \(selectedPage)")
        }
        dismiss()
    }
}

//struct KomgaReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaReaderView()
//    }
//}
