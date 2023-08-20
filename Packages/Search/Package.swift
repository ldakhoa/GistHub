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
        .package(name: "Environment", path: "../Environment"),
        .package(name: "Models", path: "../Models"),
        .package(name: "Networking", path: "../Networking"),
        .package(name: "Gist", path: "../Gist"),
        .package(name: "Profile", path: "../Profile")
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "DesignSystem",
                "Environment",
                "Models",
                "Networking",
                "Gist",
                .product(name: "UserProfile", package: "Profile")
            ]
        ),
        .testTarget(
            name: "SearchTests",
            dependencies: ["Search"]
        )
    ]
)
