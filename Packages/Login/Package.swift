// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]
        )
    ],
    dependencies: [
        // Local package dependencies
         .package(name: "DesignSystem", path: "../DesignSystem"),
         .package(name: "Networking", path: "../Networking"),
         .package(name: "AppAccount", path: "../AppAccount"),
         .package(name: "Environment", path: "../Environment"),
         .package(name: "Utilities", path: "../Utilities")
        // Third package dependencies
        // .package(url: "url", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                "DesignSystem",
                "Networking",
                "AppAccount",
                "Utilities",
                "Environment"
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        )
    ]
)
