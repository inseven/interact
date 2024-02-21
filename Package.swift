// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Interact",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Interact",
            targets: ["Interact"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/inseven/licensable", from: "0.0.11"),
    ],
    targets: [
        .target(
            name: "Interact",
            dependencies: [
                .product(name: "Licensable", package: "licensable"),
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "InteractTests",
            dependencies: ["Interact"]),
    ]
)
