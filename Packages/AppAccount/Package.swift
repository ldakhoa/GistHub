// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "AppAccount",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "AppAccount",
            targets: ["AppAccount"]
        )
    ],
    dependencies: [
        // Local package dependencies
        // .package(name: "Package name", path: "../Package name"),
        // Third package dependencies
        // .package(url: "url", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppAccount",
            dependencies: []
        ),
        .testTarget(
            name: "AppAccountTests",
            dependencies: ["AppAccount"]
        )
    ]
)
