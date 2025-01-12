//
//  SearchTab.swift
//  Dokusho
//
//  Created by Tyler Baker on 12/17/24.
//

import SwiftUI

struct SearchTab: View {
    @State private var routerPath = RouterPath()
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            SearchView()
                .withAppRouter()
        }
        .environment(routerPath)
    }
}

#Preview {
    SearchTab()
}
