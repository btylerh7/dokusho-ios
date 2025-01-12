//
//  LibraryTab.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import SwiftUI
import Observation

struct LibraryTab: View {
    @State private var routerPath = RouterPath()
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            LibraryView()
                .withAppRouter()
        }
        .environment(routerPath)
    }
}

#Preview {
    LibraryTab()
}
