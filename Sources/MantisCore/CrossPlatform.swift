//
//  CrossPlatform.swift
//  MantisCore
//
//  Cross-platform type aliases and protocols for UIKit/AppKit compatibility.
//

#if canImport(UIKit)
import UIKit
public typealias MantisColor = UIColor
public typealias MantisImage = UIImage
public typealias MantisView = UIView

public protocol ActivityIndicatorProtocol: UIView {
    func startAnimating()
    func stopAnimating()
}
#elseif canImport(AppKit)
import AppKit
public typealias MantisColor = NSColor
public typealias MantisImage = NSImage
public typealias MantisView = NSView

public protocol ActivityIndicatorProtocol: NSView {
    func startAnimating()
    func stopAnimating()
}
#endif

public enum CropToolbarMode {
    case normal
    case embedded // Without cancel and crop buttons
}

enum RatioType {
    case horizontal
    case vertical
}
