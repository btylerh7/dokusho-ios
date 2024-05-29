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
                guard let result = await Komgav2APIService.shared.getSeriesThumbnail(seriesId: self.id) else {
                    return
                }
                self.url = URL(string: result)
                makeImageRequest()
                break
            case .book:
                guard let result = await Komgav2APIService.shared.getBookThumbnail(bookId: self.id) else {
                    return
                }
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
        
        // TODO: Add guards here
        let serverUsername = UserDefaults.standard.object(forKey: "komga-server-username") as! String
        let serverPassword = UserDefaults.standard.object(forKey: "komga-server-password") as! String
        // Set the Authorization header with the basic authentication credentials
        let credentials = "\(serverUsername):\(serverPassword)".data(using: .utf8)?.base64EncodedString() ?? ""
        let authString = "Basic \(credentials)"
        urlRequest.setValue(authString, forHTTPHeaderField: "Authorization")
        request = ImageRequest(urlRequest: urlRequest)
        
        self.request = request
    }
}

//struct KomgaLazyImage_Previews: PreviewProvider {
//    static var previews: some View {
//        KomgaLazyImage()
//    }
//}
