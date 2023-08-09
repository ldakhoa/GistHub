// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]
        )
    ],
    dependencies: [
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Environment", path: "../Environment")
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "DesignSystem",
                "Environment"
            ]
        ),
        .testTarget(
            name: "SearchTests",
            dependencies: ["Search"]
        )
    ]
)
