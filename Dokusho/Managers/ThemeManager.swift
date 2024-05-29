//
//  ThemeManager.swift
//  Dokusho
//
//  Created by Tyler Baker on 7/5/23.
//  Heavy inspiration from Ice Cubes theme implementation https://github.com/Dimillian/IceCubesApp/blob/main/Packages/DesignSystem/Sources/DesignSystem/Theme.swift
//

import SwiftUI
import Combine
import Observation


enum AccentColor {
    case red
    case blue
    case purple
    
    var color: Color {
        switch self {
        case .red:
            return Color(.systemRed)
        case .blue:
            return Color(.systemBlue)
        case .purple:
            return Color(.systemPurple)
        }
    }
}

public enum ColorSetName: String {
    case defaultTheme = "System Theme"
    case purpleTheme = "Purple Theme"
}


public protocol ColorSet {
    var name: ColorSetName { get }
    var primaryColor: Color { get set }
    var secondaryColor: Color { get set }
    var textColor: Color { get set }
    var listBackgroundColor: Color { get set }
}

public struct ColorSetItem: Identifiable {
    public var id: String {
        theme.name.rawValue
    }
    public let theme: ColorSet
}
public let availableColorSets: [ColorSetItem] = [
    .init(theme: DefaultColorSet()),
    .init(theme: PurpleColorSet())
]
public struct DefaultColorSet: ColorSet {
    public var name = ColorSetName.defaultTheme
    public var primaryColor: Color = Color(.systemBackground)
    public var secondaryColor: Color = Color(.secondarySystemBackground)
    public var textColor: Color = Color(.label)
    public var listBackgroundColor: Color = Color(.secondarySystemBackground)
    
    init() {}
}

public struct PurpleColorSet: ColorSet {
    public var name = ColorSetName.purpleTheme
    public var primaryColor: Color = Color("Lavender_Accent")
    public var secondaryColor: Color = Color("Lavender_Primary")
    public var textColor: Color = Color(.white)
    public var listBackgroundColor: Color = Color(.secondarySystemBackground)
    
    init() {}
}
// Reference: https://github.com/Dimillian/IceCubesApp/blob/main/Packages/DesignSystem/Sources/DesignSystem/Resources/Colors.swift
extension Color: RawRepresentable {
  public init?(rawValue: Int) {
    let red = Double((rawValue & 0xFF0000) >> 16) / 0xFF
    let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
    let blue = Double(rawValue & 0x0000FF) / 0xFF
    self = Color(red: red, green: green, blue: blue)
  }

  public var rawValue: Int {
    guard let coreImageColor else {
      return 0
    }
    let red = Int(coreImageColor.red * 255 + 0.5)
    let green = Int(coreImageColor.green * 255 + 0.5)
    let blue = Int(coreImageColor.blue * 255 + 0.5)
    return (red << 16) | (green << 8) | blue
  }

  private var coreImageColor: CIColor? {
    CIColor(color: .init(self))
  }
}

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
}

@MainActor
@Observable
public final class Theme {
    final class ThemeStorage {
        enum ThemeKey: String {
            case primaryColor
            case secondaryColor
            case textColor
            case listBackgroundColor
        }
        @AppStorage("is_previously_set") public var isThemePreviouslySet: Bool = false
        @AppStorage(ThemeKey.primaryColor.rawValue) public var primaryColor: Color = Color(.systemBlue)
        @AppStorage(ThemeKey.secondaryColor.rawValue) public var secondaryColor: Color = Color(.systemBackground)
        @AppStorage(ThemeKey.textColor.rawValue) public var textColor: Color = Color(.label)
        @AppStorage(ThemeKey.listBackgroundColor.rawValue) public var listBackgroundColor: Color = Color(.secondarySystemBackground)
        
        init() {}
        
    }
    public static var allColorSets: [ColorSet] = [
        DefaultColorSet(),
        PurpleColorSet()
    ]
    let themeStorage = ThemeStorage()
    
    public var isThemePreviouslySet: Bool {
        didSet {
            themeStorage.isThemePreviouslySet = isThemePreviouslySet
        }
    }
    public var primaryColor: Color {
        didSet {
            themeStorage.primaryColor = primaryColor
        }
    }
    public var secondaryColor: Color {
        didSet {
            themeStorage.secondaryColor = secondaryColor
        }
    }
    public var textColor: Color {
        didSet {
            themeStorage.textColor = textColor
        }
    }
    public var listBackgroundColor: Color {
        didSet {
            themeStorage.listBackgroundColor = listBackgroundColor
        }
    }

    private init() {
        isThemePreviouslySet = themeStorage.isThemePreviouslySet
        primaryColor = themeStorage.primaryColor
        secondaryColor = themeStorage.secondaryColor
        textColor = themeStorage.textColor
        listBackgroundColor = themeStorage.listBackgroundColor
    }
    public var selectedSet: ColorSetName = .defaultTheme
    
    public static let shared = Theme()
    
    public func applySet(set: ColorSetName) {
        selectedSet = set
        setColor(withName: set)
    }
    
    public func setColor(withName name: ColorSetName) {
        let colorSet: ColorSet = Theme.allColorSets.filter { $0.name == name }.first ?? DefaultColorSet()
        
        primaryColor = colorSet.primaryColor
        secondaryColor = colorSet.secondaryColor
        textColor = colorSet.textColor
        listBackgroundColor = colorSet.listBackgroundColor
        selectedSet = name
    }

}
