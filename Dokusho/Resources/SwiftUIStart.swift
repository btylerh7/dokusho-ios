//
//  SwiftUIStart.swift
//  Dokusho
//
//  Created by Tyler Baker on 6/4/23.
//

import Foundation
import SwiftUI
import SwiftData

@main
struct FSApp: App {
    @AppStorage("isFirstTimeAppLaunch") private var isFirstTimeLaunch: Bool = true
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .modelContainer(for: HistoryItem.self)
                .modelContainer(for: MangaItem.self)
                .modelContainer(CategoryContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
                .modelContainer(for: ChapterItem.self)
                .withEnvironments()
        }
    }
}


