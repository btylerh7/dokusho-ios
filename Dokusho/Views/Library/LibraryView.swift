//
//  LibraryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(Theme.self) private var theme
    @Query var categories: [CategoryItem]
    
    var body: some View {
        List(categories, id:\.self) {category in
            NavigationLink(value: category) {
                Text(category.title)
                    .foregroundColor(theme.textColor)
            }
            .listRowBackground(theme.listBackgroundColor)

        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Library")
        .background(theme.secondaryColor)
        .navigationDestination(for: String.self) { category in
            CategoryView(category: category)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryView()
        }
    }
}
