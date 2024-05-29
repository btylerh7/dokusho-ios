//
//  KomgaReaderView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI

struct KomgaReaderView: View {
    @State var book: Book
    @State var pages: [BookPage] = []
    @State var isPresentingScannedTextView = false
    @State var isShowingOverlay = false
    @State var scannedText: String = ""
    @State var selectedPage: Int = 0
    @State var opacity: Double = 1
    @Environment(\.dismiss) var dismiss
    
    var scannedTextView: some View {
        ScrollView(.horizontal) {
            HStack {
                Button {
                    isShowingOverlay = false
                } label: {
                    Image(systemName: "x.circle.fill")
                }
                Text(scannedText)
                    .font(.system(size: 30))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .textSelection(.enabled)
                
            }
            
        }
        .frame(maxHeight: 60)
        .background(Color(.black).opacity(0.7))
        .offset(y: -50)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "x.circle.fill")
                    .onTapGesture {
                        Task {
                            await Komgav2APIService.shared.setReadingProgress(bookId: book.id, page: selectedPage, total: book.media.pagesCount)
                            dismiss()
                        }
                        
                    }
                Spacer()
                Text(book.metadata.title)
                    .font(.headline)
                Spacer()
            }
            .opacity(opacity)
            .disabled(opacity == 1 ? false : true)
            .padding()
            TabView(selection: $selectedPage) {
                ForEach((1...book.media.pagesCount), id:\.self) { page in
                    KomgaImageView(scannedText: $scannedText, bookId: book.id, page: page)
                        .tag(page)
                        .overlay(isShowingOverlay ? scannedTextView : nil, alignment: .bottom)
                }
            }
            .tabViewStyle(PageTabViewStyle())
//            .environment(\.layoutDirection, .rightToLeft)
            HStack {
                Button {
                    opacity = opacity == 1 ? 0 : 1
                } label: {
                    Image(systemName: opacity == 0 ? "eye.slash" : "eye.slash.fill")
                }
                Button {
                    isShowingOverlay.toggle()
                } label: {
                    Image(systemName: isShowingOverlay == true ? "chevron.down" : "chevron.up")
                }
                
                Text("Page \(selectedPage) of \(book.media.pagesCount)")
                    .opacity(opacity)
            }
        }
        .onChange(of: scannedText) { newValue in
            //            isPresentingScannedTextView = true
            print("confused")
            if newValue != "" {
                isShowingOverlay = true
                print("set overlay true")
            }
        }
        .task {
            guard let page = book.readProgress?.page else {return}
            
            self.selectedPage = page
        }
        
    }
}

extension KomgaReaderView {
    func createPages() {
        for i in 1...book.media.pagesCount {
            let pageNumber = i
            let url = Komgav2APIService.shared.getBookPageUrl(bookId: book.id, page: i)
        }
    }
}

//struct KomgaReaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaReaderView()
//    }
//}
