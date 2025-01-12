//
//  SettingsTab.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import SwiftUI

struct SettingsTab: View {
    @State private var routerPath = RouterPath()
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            SettingsView()
                .withAppRouter()
        }
        .environment(routerPath)
    }
}

#Preview {
    SettingsTab()
}
