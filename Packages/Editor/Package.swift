// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Editor",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Editor",
            targets: ["Editor"]
        ),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Environment", path: "../Environment"),
        .package(name: "Utilities", path: "../Utilities"),
        .package(
            url: "https://github.com/simonbs/Runestone",
            .upToNextMajor(from: "0.2.9")
        ),
        .package(
            url: "https://github.com/simonbs/KeyboardToolbar",
            .upToNextMajor(from: "0.1.1")
        ),
    ],
    targets: [
        .target(
            name: "Editor",
            dependencies: [
                "Runestone",
                "Models",
                "Environment",
                "Utilities",
                "KeyboardToolbar"
            ]
        ),
        .testTarget(
            name: "EditorTests",
            dependencies: ["Editor"]
        ),
    ]
)
