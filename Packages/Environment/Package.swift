// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Environment",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Environment",
            targets: ["Environment"]
        )
    ],
    dependencies: [
        .package(name: "Utilities", path: "../Utilities"),
        .package(name: "Networking", path: "../Networking"),
        .package(
            url: "https://github.com/simonbs/Runestone",
            .upToNextMajor(from: "0.3.2")
        )
    ],
    targets: [
        .target(
            name: "Environment",
            dependencies: [
                "Runestone",
                "Networking",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "EnvironmentTests",
            dependencies: ["Environment"]
        )
    ]
)
