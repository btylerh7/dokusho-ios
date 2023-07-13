//
//  ThemeManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/5/23.
//

import Foundation
import SwiftUI

struct Theme {
    var name: String
    var primaryColor: Color // Accent color
    var secondaryColor: Color
    var textColor: Color
    var listBackgroundColor: Color
    
}




class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    var themes: [Theme] = [
        Theme(name: "purpleTheme", primaryColor: Color("Lavender_Accent"), secondaryColor: Color("Lavender_Primary"), textColor: Color(.white), listBackgroundColor: Color("Lavender_List_Background")),
        Theme(name: "systemDefault", primaryColor: Color(.secondarySystemBackground), secondaryColor: Color(.systemBackground), textColor: Color(.label), listBackgroundColor: Color(.secondarySystemBackground))
        
        
    ]
    @Published var currentTheme: Theme

    private init() {
        // Load the current theme from UserDefaults
        if let theme = UserDefaults.standard.object(forKey: "currentTheme") as? Theme {
            currentTheme = theme
        }
        else {
            currentTheme = themes[0]
        }
    }

    func saveCurrentTheme() {
        // Save the current theme to UserDefaults
        UserDefaults.standard.set(currentTheme, forKey: "currentTheme")
    }
}
