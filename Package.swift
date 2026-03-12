// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mantis",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macCatalyst(.v13), .macOS(.v13)],
    products: [
        .library(
            name: "Mantis",
            targets: ["Mantis"])
    ],
    targets: [
        // Shared Foundation/CoreGraphics code, config types, and cross-platform helpers.
        .target(
            name: "MantisShared",
            exclude: ["Info.plist", "Resources/Info.plist"],
            resources: [.process("Resources")],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        // UIKit/iOS implementations. Depends on MantisShared and re-exports it.
        .target(
            name: "MantisIOS",
            dependencies: ["MantisShared"],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        // AppKit/macOS implementations. Depends on MantisShared and re-exports it.
        .target(
            name: "MantisMacos",
            dependencies: ["MantisShared"],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        // Umbrella target: re-exports MantisIOS on iOS/Catalyst, MantisMacos on macOS.
        .target(
            name: "Mantis",
            dependencies: [
                .target(name: "MantisIOS", condition: .when(platforms: [.iOS, .macCatalyst])),
                .target(name: "MantisMacos", condition: .when(platforms: [.macOS]))
            ]
        )
    ]
)
