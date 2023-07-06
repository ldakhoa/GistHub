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
        // Local package dependencies
        // .package(name: "Package name", path: "../Package name"),
        // Third package dependencies
        // .package(url: "url", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Editor",
            dependencies: []
        ),
        .testTarget(
            name: "EditorTests",
            dependencies: ["Editor"]
        ),
    ]
)
