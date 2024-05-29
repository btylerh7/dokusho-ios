//
//  Color.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/2/23.
//

import Foundation
import SwiftUI

extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let hex = String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        return hex
    }
}
