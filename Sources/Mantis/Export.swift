//
//  Export.swift
//  Mantis
//
//  Umbrella module that re-exports the appropriate platform target.
//

@_exported import MantisCore

#if canImport(UIKit)
@_exported import MantisIOS
#elseif canImport(AppKit)
@_exported import MantisMacos
#endif
