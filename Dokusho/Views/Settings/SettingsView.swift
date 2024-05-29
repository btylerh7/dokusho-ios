//
//  SettingsView.swift
//  Dokusho
//
//  Created by Tyler Baker on 3/6/23.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @State var isDisplayingCategoryModal = false
    @Environment(Theme.self) private var theme
//    @State var selectedTheme: String
    @State var numberOfColumns = UserDefaults.standard.object(forKey: "numberOfColums") as? Int ?? 2
    @State var serverAddress = ""
    @State var serverUsername = ""
    @State var serverPassword = ""
    var fetchRequest: NSFetchRequest<HistoryObject> {
        let fetchRequest = HistoryObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mangaId == %@", "ayakashi-triangle")
        return fetchRequest
    }
    
    var body: some View {
        List {
            Section("Categories") {
                Button(action: {
                    
                }, label: {
                    Text("Add Category")
                })
                .onTapGesture {
                    self.isDisplayingCategoryModal.toggle()
                }
                Button("Delete All Categories") {
                    let request = CategoryObject.fetchRequest()
                    CoreDataManager.shared.clear(request: request)
                }
            }
            Section("Library") {
                
                Stepper("Columns Per Row: \(numberOfColumns)", value: $numberOfColumns, in: 1...3)
                Button(action: {
                    CoreDataManager.shared.clear(request: LibraryEntryObject.fetchRequest())
                }, label: {
                    Text("Clear library")
                })
                .foregroundColor(Color(.systemRed))
            }
            Section("Komga") {
                TextField("Server Address", text: $serverAddress)
                TextField("Server Username", text: $serverUsername)
                SecureField("Server Password", text: $serverPassword)
                Button("Set Komga Info") {
                    UserDefaults.standard.set(serverAddress, forKey: "komga-server-address")
                    UserDefaults.standard.set(serverUsername, forKey: "komga-server-username")
                    UserDefaults.standard.set(serverPassword, forKey: "komga-server-password")
                }
            }
//            Section("Theme") {
//                Picker("Current Theme", selection: $selectedTheme) {
//                    ForEach(Theme.allColorSets, id:\.self) { colorSet in
//                        Text(colorSet.name)
//                    }
//                }
//            }
        }
        .navigationTitle("Settings")
        .fullScreenCover(isPresented: $isDisplayingCategoryModal) {
            AddCategoryView()
        }
        .onChange(of: numberOfColumns) { newValue in
            UserDefaults.standard.set(newValue, forKey: "numberOfColums")
        }
//        .onChange(of: theme, perform: { newValue in
//            ThemeManager.shared.currentTheme = newValue
//            ThemeManager.shared.saveCurrentTheme()
//        })
        .onAppear {
//            selectedTheme = theme.selectedSet
            if let server = UserDefaults.standard.object(forKey: "komga-server-address") as? String {
                serverAddress = server
            }
            if let username = UserDefaults.standard.object(forKey: "komga-server-username") as? String {
                serverUsername = username
            }
            if let password = UserDefaults.standard.object(forKey: "komga-server-password") as? String {
                serverPassword = password
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

