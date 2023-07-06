// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
         .package(name: "Environment", path: "../Environment"),
        .package(url: "https://github.com/duytph/Networkable", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                "Models",
                "Networkable",
                "Environment"
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
    ]
)
