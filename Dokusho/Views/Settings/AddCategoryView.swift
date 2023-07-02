//
//  AddCategoryView.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/18/23.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(fetchRequest: CategoryObject.all()) var categories
    @State var text = ""
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Text("Manage Categories")
                Spacer()
                Button("Done") {
                    dismiss()
                }
            }
            Form {
                TextField("Enter Title", text: $text)
                    .scrollDismissesKeyboard(.automatic)
                
                Button(action: {
                    addCategory()
                    dismiss()
                }, label: {
                    Text("Add")
                })
                ForEach(categories, id:\.self) { category in
                    Text(category.categoryId ?? "whoops")
                }
            }
        }
    }
    private func addCategory() {
        CoreDataManager.shared.addToCategories(text: self.text)
//        let context = CoreDataManager.shared.viewContext
//        let categoryEntry = CategoryObject(context: context)
//        categoryEntry.categoryId = self.text
//        categoryEntry.title = self.text
//        categoryEntry.libraryEntries = NSSet()
//        try? context.save()
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
