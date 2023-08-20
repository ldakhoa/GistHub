// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Profile",
            targets: ["Profile"]
        ),
        .library(
            name: "UserProfile",
            targets: ["UserProfile"]
        ),
        .library(
            name: "Settings",
            targets: ["Settings"]
        )
    ],
    dependencies: [
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Networking", path: "../Networking"),
        .package(name: "AppAccount", path: "../AppAccount"),
        .package(name: "Models", path: "../Models"),
        .package(name: "Utilities", path: "../Utilities"),
        .package(name: "Editor", path: "../Editor")
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: [
                "Networking",
                "Models",
                "Settings",
                "DesignSystem"
            ]
        ),
        .target(
            name: "UserProfile",
            dependencies: [
                "Networking",
                "Models",
                "Settings",
                "DesignSystem"
            ]
        ),
        .testTarget(
            name: "ProfileTests",
            dependencies: ["Profile"]
        ),
        .target(
            name: "Settings",
            dependencies: [
                "Networking",
                "Models",
                "AppAccount",
                "DesignSystem",
                "Editor",
                "Utilities"
            ]
        )
    ]
)
