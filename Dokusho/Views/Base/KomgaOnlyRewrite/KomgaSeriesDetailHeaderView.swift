//
//  KomgaSeriesDetailHeaderView.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI

struct KomgaSeriesDetailHeaderView: View {
    @Binding var series: Series
    @Binding var authors: String
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                KomgaLazyImage(id: series.id, type: .series, width: 100)
                    .frame(maxHeight: 140)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(series.metadata.title)
                        .font(.title3)
                        .bold()
                    Text("\(authors != "" ? authors : "Author Unknown")")
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))

                    Text(series.metadata.language != "" ? "Language: \(series.metadata.language)" : "Language: n/a")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                    

                }
                .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack {
                ForEach(series.metadata.genres, id:\.self) {tag in
                    KomgaSeriesTagPillView(title: tag)
                }
                ForEach(series.metadata.tags, id:\.self) {tag in
                    KomgaSeriesTagPillView(title: tag)
                }
                Spacer()
            }
            .padding(.vertical, 10)
            Text(series.metadata.summary)
                .font(.callout)
//                .font(.system(size: 15))
        }
        .padding(.horizontal)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .foregroundColor(Color(.label)) // TODO: match theme
        .textCase(.none)
    }
}

//struct KomgaSeriesDetailHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaSeriesDetailHeaderView()
//    }
//}
