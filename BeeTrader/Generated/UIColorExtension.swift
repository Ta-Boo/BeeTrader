// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


// MARK: - Color catalogs
import UIKit

@objc public extension UIColor {

  static let accentColor = UIColor.color(named: "AccentColor")
  static let accentTomatoColor = UIColor.color(named: "AccentTomatoColor")
  static let primaryColor = UIColor.color(named: "PrimaryColor")
  static let secondaryColor = UIColor.color(named: "SecondaryColor")
  static let textColor = UIColor.color(named: "TextColor")
  static let allColors: [UIColor] = [
    accentColor,
    accentTomatoColor,
    primaryColor,
    secondaryColor,
    textColor,
  ]

  static let allNames: [String] = [
    "accentColor",
    "accentTomatoColor",
    "primaryColor",
    "secondaryColor",
    "textColor",
  ]

  private static func color(named: String) -> UIColor {
      return UIColor(named: named)!
  }
}
