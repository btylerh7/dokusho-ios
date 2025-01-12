//
//  KomgaLazyImage.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/30/23.
//

import SwiftUI
import NukeUI

public enum LazyImageType {
    case series
    case book
}

struct KomgaLazyImage: View {
    @Environment(NetworkManager.self) private var client
    @State var id: String
    @State var type: LazyImageType
    @State var url: URL? = nil
    @State var width: CGFloat
    @State var request: ImageRequest? = nil
    var body: some View {
        LazyImage(request: request) { state in
            if state.error != nil {
                Text("Error: \(state.error!.localizedDescription)")
            }
            if state.isLoading {
                ProgressView()
            } else {
                state.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: width)
                    .clipped()
                    .cornerRadius(10)
            }
            
            
        }
        .task {
            switch type {
            case .series:
                let result = client.getSeriesThumbnail(seriesId: self.id)
                self.url = URL(string: result)
                makeImageRequest()
                break
            case .book:
                let result = client.getBookThumbnail(bookId: self.id)
                self.url = URL(string: result)
                makeImageRequest()
                break
            }
            
        }
    }
}
extension KomgaLazyImage {
    func makeImageRequest() {
        guard let url = self.url else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest = client.addHeadersToRequest(request: &urlRequest, method: nil)
        request = ImageRequest(urlRequest: urlRequest)
        
        self.request = request
    }
}

//struct KomgaLazyImage_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaLazyImage()
//    }
//}
