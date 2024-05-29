//
//  BookTileView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import NukeUI

struct BookTileView: View {
    @Environment(Theme.self) private var theme
    @State var book: Book
    @State var url: URL? = nil
    @State var request: ImageRequest? = nil
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            ZStack (alignment:.bottom) {
                GeometryReader { geo in
                    KomgaLazyImage(id: book.id, type: .book, width: geo.size.width)
                }
                VStack {
                    Text(book.metadata.title)
                        .font(.headline)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        
                    ProgressView(value: Float(book.readProgress?.page ?? 0), total: Float(book.media.pagesCount))
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(theme.primaryColor)
                        .padding(.horizontal)
                }
                .foregroundColor(Color(.white))
                .background(Color(.systemGray).opacity(0.1))
                .shadow(color: Color(.black), radius: 10.0)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            }
            .padding()
            .frame(width: 200, height: 300)
        }
    }
}



