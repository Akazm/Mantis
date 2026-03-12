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
import QuartzCore

// MARK: - Simple Type Aliases
public typealias UIColor = NSColor
public typealias UIFont = NSFont
public typealias UIImage = NSImage
public typealias UIView = NSView
public typealias UIViewController = NSViewController
public typealias UIBezierPath = NSBezierPath
public typealias UIEdgeInsets = NSEdgeInsets
public typealias UIImageView = NSImageView
public typealias UIScrollView = NSScrollView
public typealias UIStackView = NSStackView
public typealias UIGestureRecognizer = NSGestureRecognizer
public typealias UITapGestureRecognizer = NSClickGestureRecognizer
public typealias UIPanGestureRecognizer = NSPanGestureRecognizer
public typealias UILayoutPriority = NSLayoutConstraint.Priority
public typealias UILabel = NSTextField
public typealias UIButton = NSButton

// MARK: - UIRectEdge Stub
public struct UIRectEdge: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public static let all = UIRectEdge(rawValue: 15)
}

// MARK: - UIDevice Compatibility
public class UIDevice {
    public static let current = UIDevice()
    public enum UserInterfaceIdiom {
        case phone, pad, mac, unspecified
    }
    public var userInterfaceIdiom: UserInterfaceIdiom { .mac }
}

// MARK: - NSView Extensions (UIView Compatibility)
extension NSView {
    @objc public var backgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }

    public var clipsToBounds: Bool {
        get { layer?.masksToBounds ?? false }
        set { wantsLayer = true; layer?.masksToBounds = newValue }
    }

    public var alpha: CGFloat {
        get { alphaValue }
        set { alphaValue = newValue }
    }

    public var isUserInteractionEnabled: Bool {
        get { true }
        set { /* no-op on macOS */ }
    }

    public var center: CGPoint {
        get { CGPoint(x: frame.midX, y: frame.midY) }
        set { frame.origin = CGPoint(x: newValue.x - frame.width / 2, y: newValue.y - frame.height / 2) }
    }

    public var transform: CGAffineTransform {
        get { layer?.affineTransform() ?? .identity }
        set { wantsLayer = true; layer?.setAffineTransform(newValue) }
    }

    public func setNeedsLayout() { needsLayout = true }
    public func layoutIfNeeded() { layoutSubtreeIfNeeded() }

    public func bringSubviewToFront(_ view: NSView) {
        view.removeFromSuperview()
        addSubview(view, positioned: .above, relativeTo: subviews.last)
    }

    public struct AnimationOptions: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        public static let curveEaseInOut = AnimationOptions(rawValue: 0)
        public static let curveEaseIn = AnimationOptions(rawValue: 1 << 16)
        public static let curveEaseOut = AnimationOptions(rawValue: 2 << 16)
        public static let beginFromCurrentState = AnimationOptions(rawValue: 1 << 2)
    }

    public class func animate(withDuration duration: TimeInterval,
                              animations: @escaping () -> Void) {
        animate(withDuration: duration, delay: 0, options: [],
                animations: animations, completion: nil)
    }

    public class func animate(withDuration duration: TimeInterval,
                              animations: @escaping () -> Void,
                              completion: ((Bool) -> Void)?) {
        animate(withDuration: duration, delay: 0, options: [],
                animations: animations, completion: completion)
    }

    public class func animate(withDuration duration: TimeInterval,
                              delay: TimeInterval,
                              options: AnimationOptions = [],
                              animations: @escaping () -> Void,
                              completion: ((Bool) -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            animations()
        }, completionHandler: {
            completion?(true)
        })
    }
}

// MARK: - NSViewController Extensions (UIViewController Compatibility)
extension NSViewController {
    @objc open var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }
}

// MARK: - NSImage Extensions (UIImage Compatibility)
extension NSImage {
    public var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }

    public convenience init?(cgImage: CGImage) {
        self.init(cgImage: cgImage,
                  size: NSSize(width: cgImage.width, height: cgImage.height))
    }

    public var scale: CGFloat { 1.0 }
}

// MARK: - NSEdgeInsets Extensions
extension NSEdgeInsets {
    public static let zero = NSEdgeInsets()
}

// MARK: - NSScrollView Extensions (UIScrollView Compatibility)
extension NSScrollView {
    public var contentOffset: CGPoint {
        get { contentView.bounds.origin }
        set { contentView.scroll(to: newValue); reflectScrolledClipView(contentView) }
    }

    public var contentSize: CGSize {
        get { documentView?.frame.size ?? .zero }
        set { documentView?.setFrameSize(newValue) }
    }

    public var contentInset: NSEdgeInsets {
        get { contentInsets }
        set { contentInsets = newValue }
    }

    public var zoomScale: CGFloat {
        get { magnification }
        set { magnification = newValue }
    }

    public var minimumZoomScale: CGFloat {
        get { minMagnification }
        set { minMagnification = newValue }
    }

    public var maximumZoomScale: CGFloat {
        get { maxMagnification }
        set { maxMagnification = newValue }
    }

    public func setZoomScale(_ scale: CGFloat, animated: Bool) {
        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                self.animator().magnification = scale
            }
        } else {
            magnification = scale
        }
    }

    public func zoom(to rect: CGRect, animated: Bool) {
        magnify(toFit: rect)
    }

    public var isScrollEnabled: Bool {
        get { true }
        set { /* no-op */ }
    }

    public var bouncesZoom: Bool {
        get { true }
        set { /* no-op */ }
    }

    public var delegate: NSObject? {
        get { nil }
        set { /* handled via notifications on AppKit */ }
    }
}

// MARK: - NSTextField Extensions (UILabel Compatibility)
extension NSTextField {
    public var text: String? {
        get { stringValue }
        set { stringValue = newValue ?? "" }
    }

    public var textAlignment: NSTextAlignment {
        get { alignment }
        set { alignment = newValue }
    }

    public var numberOfLines: Int {
        get { maximumNumberOfLines }
        set { maximumNumberOfLines = newValue }
    }

    public var adjustsFontSizeToFitWidth: Bool {
        get { false }
        set { /* no-op */ }
    }

    public var minimumScaleFactor: CGFloat {
        get { 0 }
        set { /* no-op */ }
    }
}

// MARK: - NSButton Extensions (UIButton Compatibility)
extension NSButton {
    public struct ButtonType {
        public static let system = ButtonType()
        public static let custom = ButtonType()
    }

    public struct ControlState: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        public static let normal = ControlState(rawValue: 0)
        public static let highlighted = ControlState(rawValue: 1 << 0)
        public static let disabled = ControlState(rawValue: 1 << 1)
        public static let selected = ControlState(rawValue: 1 << 2)
    }

    public struct ControlEvent: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        public static let touchUpInside = ControlEvent(rawValue: 1 << 6)
    }

    public static func makeButton(type: ButtonType) -> NSButton {
        let button = NSButton(frame: .zero)
        button.isBordered = false
        button.bezelStyle = .regularSquare
        return button
    }

    public func setTitle(_ title: String?, for state: ControlState) {
        self.title = title ?? ""
    }

    public func setImage(_ image: NSImage?, for state: ControlState) {
        self.image = image
    }

    public func addTarget(_ target: AnyObject?, action: Selector,
                          for controlEvents: ControlEvent) {
        self.target = target
        self.action = action
    }

    public var isSelected: Bool {
        get { state == .on }
        set { state = newValue ? .on : .off }
    }

    public var titleLabel: NSTextField? { nil }
}

// MARK: - NSBezierPath Extensions (UIBezierPath Compatibility)
extension NSBezierPath {
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0..<elementCount {
            let element = self.element(at: i, associatedPoints: &points)
            switch element {
            case .moveTo: path.move(to: points[0])
            case .lineTo: path.addLine(to: points[0])
            case .curveTo: path.addCurve(to: points[2],
                                          control1: points[0], control2: points[1])
            case .closePath: path.closeSubpath()
            case .cubicCurveTo: path.addCurve(to: points[2],
                                               control1: points[0], control2: points[1])
            case .quadraticCurveTo: path.addQuadCurve(to: points[1], control: points[0])
            @unknown default: break
            }
        }
        return path
    }

    public convenience init(arcCenter center: CGPoint, radius: CGFloat,
                            startAngle: CGFloat, endAngle: CGFloat,
                            clockwise: Bool) {
        self.init()
        appendArc(withCenter: center, radius: radius,
                  startAngle: startAngle * 180.0 / .pi,
                  endAngle: endAngle * 180.0 / .pi,
                  clockwise: !clockwise) // AppKit reverses clockwise convention
    }

    public func addLine(to point: CGPoint) {
        line(to: point)
    }

    public func addCurve(to point: CGPoint, controlPoint1: CGPoint,
                         controlPoint2: CGPoint) {
        curve(to: point, controlPoint1: controlPoint1,
              controlPoint2: controlPoint2)
    }
}

// MARK: - NSImageView Extensions
extension NSImageView {
    public var contentMode: Int {
        get { 0 }
        set { imageScaling = .scaleProportionallyUpOrDown }
    }
}

// MARK: - NSStackView Extensions (UIStackView Compatibility)
extension NSStackView {
    public var axis: NSUserInterfaceLayoutOrientation {
        get { orientation }
        set { orientation = newValue }
    }
}

// MARK: - UIActivityIndicatorView Compatibility
public class UIActivityIndicatorView: NSProgressIndicator {
    public enum Style { case large, medium }

    public convenience init(style: Style) {
        self.init(frame: .zero)
        self.style = .spinning
        isIndeterminate = true
    }

    public var hidesWhenStopped: Bool {
        get { isDisplayedWhenStopped == false }
        set { isDisplayedWhenStopped = !newValue }
    }

    public var color: NSColor? {
        didSet { /* NSProgressIndicator does not support custom color */ }
    }
}

// MARK: - UIVisualEffectView / UIBlurEffect Compatibility
public class UIBlurEffect {
    public enum Style { case dark, light, prominent, regular }
    public let style: Style
    public init(style: Style) { self.style = style }
}

public class UIVisualEffect {}

// MARK: - UIFontMetrics Compatibility
public class UIFontMetrics {
    public static let `default` = UIFontMetrics()
    public init(forTextStyle: String = "") {}
    public func scaledFont(for font: NSFont) -> NSFont { font }
    public func scaledFont(for font: NSFont,
                           maximumPointSize: CGFloat) -> NSFont { font }
}

// MARK: - UIImpactFeedbackGenerator Compatibility
public class UIImpactFeedbackGenerator {
    public enum FeedbackStyle { case light, medium, heavy, rigid, soft }
    public init(style: FeedbackStyle) {}
    public func prepare() {}
    public func impactOccurred() {}
}

// MARK: - UISelectionFeedbackGenerator Compatibility
public class UISelectionFeedbackGenerator {
    public init() {}
    public func prepare() {}
    public func selectionChanged() {}
}

// MARK: - UIKeyCommand Compatibility
public class UIKeyCommand {
    public var input: String?
    public var modifierFlags: ModifierFlags = []
    public var action: Selector?
    public var discoverabilityTitle: String?

    public struct ModifierFlags: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        public static let command = ModifierFlags(rawValue: 1 << 20)
    }

    public convenience init(input: String, modifierFlags: ModifierFlags,
                            action: Selector) {
        self.init()
        self.input = input
        self.modifierFlags = modifierFlags
        self.action = action
    }

    public init() {}
}

// MARK: - UIScreen Compatibility
public class UIScreen {
    public static let main = UIScreen()
    public var scale: CGFloat {
        NSScreen.main?.backingScaleFactor ?? 1.0
    }
    public var bounds: CGRect {
        NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1920, height: 1080)
    }
}

// MARK: - UIAlertController / UIAlertAction Compatibility
public class UIAlertController {
    public enum Style { case actionSheet, alert }
    public var popoverPresentationController: PopoverPresentationController? { nil }
    public init(title: String?, message: String?, preferredStyle: Style) {}
    public func addAction(_ action: UIAlertAction) {}

    public class PopoverPresentationController {
        public var sourceView: NSView?
        public var sourceRect: CGRect = .zero
    }
}

public class UIAlertAction {
    public enum Style { case `default`, cancel, destructive }
    public init(title: String?, style: Style,
                handler: ((UIAlertAction) -> Void)? = nil) {}
}

// MARK: - UIAccessibility Compatibility
public struct UIAccessibility {
    public static var isVoiceOverRunning: Bool {
        NSWorkspace.shared.isVoiceOverEnabled
    }
    public static var isSwitchControlRunning: Bool { false }
    public static var isSpeakScreenEnabled: Bool { false }
}

// MARK: - Notification.Name Constants
extension Notification.Name {
    public static let UIAccessibilityVoiceOverStatusDidChange =
        NSNotification.Name("NSApplicationAccessibilityVoiceOverStatusDidChange")
}

// MARK: - UIGraphics Compatibility
public func UIGraphicsBeginImageContextWithOptions(_ size: CGSize,
                                                    _ opaque: Bool,
                                                    _ scale: CGFloat) {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size.width * (scale == 0 ? NSScreen.main?.backingScaleFactor ?? 1 : scale)),
        pixelsHigh: Int(size.height * (scale == 0 ? NSScreen.main?.backingScaleFactor ?? 1 : scale)),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: !opaque,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )
    rep?.size = size
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep!)
}

public func UIGraphicsGetCurrentContext() -> CGContext? {
    NSGraphicsContext.current?.cgContext
}

public func UIGraphicsGetImageFromCurrentImageContext() -> NSImage? {
    guard let context = NSGraphicsContext.current,
          let rep = context.cgContext.makeImage() else { return nil }
    return NSImage(cgImage: rep,
                   size: NSSize(width: rep.width, height: rep.height))
}

public func UIGraphicsEndImageContext() {
    NSGraphicsContext.current = nil
}

// MARK: - UIGraphicsImageRenderer Compatibility
public class UIGraphicsImageRenderer {
    let size: CGSize
    public init(size: CGSize) { self.size = size }
    public func image(actions: (UIGraphicsImageRendererContext) -> Void) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        let context = UIGraphicsImageRendererContext()
        context.cgContext = NSGraphicsContext.current!.cgContext
        actions(context)
        image.unlockFocus()
        return image
    }
}

public class UIGraphicsImageRendererContext {
    public var cgContext: CGContext!
}

// MARK: - UITraitCollection Compatibility
public class UITraitCollection {
    public enum UserInterfaceStyle { case light, dark, unspecified }
    public var userInterfaceStyle: UserInterfaceStyle {
        let appearance = NSApp?.effectiveAppearance ?? NSAppearance.current
        if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
            return .dark
        }
        return .light
    }
}

// MARK: - Orientation Stub (macOS doesn't have device orientations)
public struct Orientation {
    public static var isLandscape: Bool { false }
    public static var isLandscapeLeft: Bool { false }
    public static var isLandscapeRight: Bool { false }
    public static var isPortrait: Bool { true }
    public static var treatAsPortrait: Bool { true }
}

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
