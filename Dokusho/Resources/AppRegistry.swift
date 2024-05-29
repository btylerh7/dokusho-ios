//
//  AppRegistry.swift
//  Dokusho
//
//  Created by Tyler Baker on 5/28/24.
//

import Foundation
import SwiftUI

@MainActor
extension View {
    func withEnvironments() -> some View {
        environment(Theme.shared)
    }
}
