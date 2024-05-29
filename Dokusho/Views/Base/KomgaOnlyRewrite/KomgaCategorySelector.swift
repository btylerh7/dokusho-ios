//
//  KomgaCategorySelector.swift
//  Dokusho
//
//  Created by Tyler Baker on 8/1/23.
//

import SwiftUI

enum Filter {
    case all
    case filter(collection: String)
}

struct CategorySelectorTabItem: View {
    var tabName: String
    var body: some View {
        Text(tabName)
            .padding()
            .frame(minWidth: 20)
            .padding(.horizontal)
    }
}

struct KomgaCategorySelector: View {
    @Environment(Theme.self) private var theme
    @StateObject var viewModel = LibraryViewViewModel()
    @State var collectionId: String = ""
    @State var title: String = "All"
    var body: some View {
        let background = theme.secondaryColor
        let accent = theme.primaryColor
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                CategorySelectorTabItem(tabName: "All")
                    .onTapGesture {
                        title = "All"
                        collectionId = ""
                    }
                    .background(title == "All" ? accent : background)
                if viewModel.collections != nil {
                    ForEach(viewModel.collections!.content, id:\.id) { collection in
                        CategorySelectorTabItem(tabName: collection.name)
                            .onTapGesture {
                                title = collection.name
                                collectionId = collection.id
                                
                            }
                            .background(title == collection.name ? accent : background)
                    }
                }
            }
            
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .background(background)
        .foregroundColor(theme.textColor)
        
        KomgaLibraryView(id: $collectionId, title: $title, viewModel: viewModel)
    }
}

struct KomgaCategorySelector_Previews: PreviewProvider {
    static var previews: some View {
        KomgaCategorySelector()
    }
}
