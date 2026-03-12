//
//  CrossPlatform.swift
//  Mantis
//
//  Cross-platform compatibility layer for macOS support.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
public typealias UIColor = NSColor
public typealias UIFont = NSFont
#else
import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// Minimal color stub for non-Apple platforms (e.g., Linux) to allow compilation.
/// Mantis UI functionality is only available on Apple platforms (iOS, macOS via Catalyst/AppKit).
public class UIColor: NSObject {
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public convenience init(white: CGFloat, alpha: CGFloat) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }

    public static let white = UIColor(white: 1, alpha: 1)
    public static let black = UIColor(white: 0, alpha: 1)
    public static let clear = UIColor(white: 0, alpha: 0)
    public static let gray = UIColor(white: 0.5, alpha: 1)
    public static let lightGray = UIColor(white: 0.667, alpha: 1)
    public static let darkGray = UIColor(white: 0.333, alpha: 1)

    #if canImport(CoreGraphics)
    public var cgColor: CGColor {
        return CGColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    #endif

    public func withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#endif
