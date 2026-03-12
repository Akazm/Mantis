// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mantis",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macCatalyst(.v13), .macOS(.v11)],
    products: [
        .library(
            name: "Mantis",
            targets: ["Mantis"])
    ],
    targets: [
        .target(
            name: "MantisCore",
            exclude: ["Info.plist", "Resources/Info.plist"],
            resources: [.process("Resources")],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        .target(
            name: "MantisIOS",
            dependencies: ["MantisCore"],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        .target(
            name: "MantisMacos",
            dependencies: ["MantisCore"],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        .target(
            name: "Mantis",
            dependencies: [
                "MantisCore",
                .target(name: "MantisIOS", condition: .when(platforms: [.iOS, .macCatalyst])),
                .target(name: "MantisMacos", condition: .when(platforms: [.macOS]))
            ],
            swiftSettings: [.define("MANTIS_SPM")]
        ),
        .testTarget(
            name: "MantisTests",
            dependencies: ["Mantis", "MantisCore", "MantisIOS"]
        )
    ]
)
