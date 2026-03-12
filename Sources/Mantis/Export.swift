// Export.swift
// Mantis umbrella module
//
// Re-exports either MantisIOS (on iOS / Mac Catalyst) or MantisMacos (on macOS),
// giving consumers a single `import Mantis` entry point regardless of platform.

#if canImport(UIKit)
@_exported import MantisIOS
#elseif canImport(AppKit)
@_exported import MantisMacos
#endif
