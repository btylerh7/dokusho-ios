//
//  TabBarView.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import SwiftUI

struct TabBarView: View {
    @Environment(Theme.self) private var theme
    @State var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryTab()
                .tag(0)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                        .foregroundColor(theme.textColor)
                }
            SearchTab()
                .toolbarBackground(.hidden, for: .navigationBar)
                .tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .foregroundColor(theme.textColor)
                }
            
            SettingsTab()
                .tag(2)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .foregroundColor(theme.textColor)
                }
        }
        .tint(theme.primaryColor)

    }
}

#Preview {
    TabBarView()
}
