//
//  NewMangaTileView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import NukeUI

struct NewMangaTileView: View {
    @State var series: Series
    @State var url: URL? = nil
    @State var request: ImageRequest? = nil
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            ZStack (alignment:.bottom) {
                GeometryReader { geo in
                    KomgaLazyImage(id: series.id, type: .series, width: geo.size.width)
                }
                Text(series.metadata.title)
                    .font(.headline)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .padding()
                    .fontWeight(.bold)
                    .foregroundColor(Color(.white))
                    .background(Color(.systemGray).opacity(0.1))
                    .shadow(color: Color(.black), radius: 10.0)
                    .frame(maxWidth: 300)
                Spacer()
            }
            .padding()
            .frame(width: 200, height: 300)
        }
    }
}



