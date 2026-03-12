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
#endif
