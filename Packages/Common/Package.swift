// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        )
    ],
    dependencies: [
        .package(name: "Networking", path: "../Networking"),
        .package(name: "Models", path: "../Models")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "Networking",
                "Models"
            ]
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]
        )
    ]
)
