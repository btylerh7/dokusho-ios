//
//  MangaTileView.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/6/23.
//

import SwiftUI
import NukeUI



struct MangaTileView: View {
    @State public var title: String
    @State public var image: String?
    @State public var uiImage: UIImage?
    @State public var sourceId: String?
    
    @State var request: ImageRequest? = nil
    
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            ZStack (alignment:.bottom) {
                GeometryReader { geo in
                    if request != nil {
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
                                    .frame(maxWidth: geo.size.width)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            
                        }
                    }
                    if uiImage != nil {
                        Image(uiImage: uiImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: geo.size.width)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
                Text(title)
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
            .onAppear {
                if image != nil {
                    var request = ImageRequest(url: URL(string: image!))
                    
                    if sourceId == "komga" {
                        var urlRequest = URLRequest(url:URL(string: image!)!)
                        
                        // TODO: Add guards here
                        let serverUsername = UserDefaults.standard.object(forKey: "komga-server-username") as! String
                        let serverPassword = UserDefaults.standard.object(forKey: "komga-server-password") as! String
                        // Set the Authorization header with the basic authentication credentials
                        let credentials = "\(serverUsername):\(serverPassword)".data(using: .utf8)?.base64EncodedString() ?? ""
                        let authString = "Basic \(credentials)"
                        urlRequest.setValue(authString, forHTTPHeaderField: "Authorization")
                        request = ImageRequest(urlRequest: urlRequest)
                    }
                    
                    self.request = request
                }
            }
        }
    }
}
