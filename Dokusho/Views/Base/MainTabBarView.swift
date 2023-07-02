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
                    LibraryView()
            }
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(0)
            NavigationStack(path: $sourcesPath) {
                SourcesView()
            }
                .tabItem {
                    Label("Sources", systemImage: "globe")
                }
                .tag(1)
            NavigationStack(path: $searchPath) {
                SearchView()
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)
            NavigationStack(path: $settingsPath){
                SettingsView()
            }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
            
        }
        
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
