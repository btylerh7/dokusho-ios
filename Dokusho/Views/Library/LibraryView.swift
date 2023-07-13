//
//  LibraryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI

final class LibrarySwiftUIViewModel: ObservableObject {
    @Published var categories: [String] = []
    
    func getCategories() {
        categories = ["All"]
        let categoryResults = CoreDataManager.shared.getCategories()
        for categoryResult in categoryResults {
            DispatchQueue.main.async {
                self.categories.append(categoryResult.categoryId ?? "No Title")
            }
        }
    }
}

struct LibraryView: View {
    @StateObject var viewModel = LibrarySwiftUIViewModel()
    
    var body: some View {
        List(viewModel.categories, id:\.self) {category in
            NavigationLink(value: category) {
                Text(category)
                    .foregroundColor(ThemeManager.shared.currentTheme.textColor)
            }
            .listRowBackground(ThemeManager.shared.currentTheme.listBackgroundColor)

        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Library")
        .background(ThemeManager.shared.currentTheme.secondaryColor)
        .navigationDestination(for: String.self) { category in
            CategoryView(selectedCategory: category)
        }        .onAppear {
            viewModel.getCategories()
        }
        .refreshable {
            viewModel.categories = ["All"]
            viewModel.getCategories()
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
