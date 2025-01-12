//
//  MainTabBarView.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/3/23.
//

import SwiftUI

extension Binding { func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> { Binding(get: { wrappedValue }, set: { newValue in wrappedValue = newValue; closure() }) }
}

struct MainTabBarView: View {
    @Environment(Theme.self) private var theme
    @State var selection = 0
    @State var selectedTag = 0
    @State var libraryPath = NavigationPath()
    @State var sourcesPath = NavigationPath()
    @State var searchPath = NavigationPath()
    @State var settingsPath = NavigationPath()
    
    private func popToRoot() {
        switch selection {
        case 0:
            libraryPath = NavigationPath()
            break
        case 1:
            sourcesPath = NavigationPath()
            break
        case 2:
            searchPath = NavigationPath()
            break
        case 3:
            settingsPath = NavigationPath()
            break
        default:
            break
        }
    }
    var body: some View {
        TabView(selection: $selection.onUpdate({
            if selectedTag == selection {
                popToRoot()
            }
            else {
                selectedTag = selection
            }
        })) {
            NavigationStack(path:$libraryPath) {
//                    KomgaLibraryView()
                LibraryView()
            }
            .toolbarBackground(.hidden, for: .navigationBar)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                        .foregroundColor(theme.textColor)
                }
                .tag(0)
//            NavigationStack(path: $sourcesPath) {
//                SourcesView()
//            }
//            .toolbarBackground(.hidden, for: .navigationBar)
//
//                .tabItem {
//                    Label("Sources", systemImage: "globe")
//                        .foregroundColor(ThemeManager.shared.currentTheme.textColor)
//                }
//                .tag(1)
            NavigationStack(path: $searchPath) {
                SearchView()
                    .toolbarBackground(.hidden, for: .navigationBar)
            }
            
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .foregroundColor(theme.textColor)
                }
                .tag(1)
            NavigationStack(path: $settingsPath){
                SettingsView()
            }
            .toolbarBackground(.hidden, for: .navigationBar)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .foregroundColor(theme.textColor)
                }
                .tag(2)
            
        }
        .tint(theme.primaryColor)
        
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
