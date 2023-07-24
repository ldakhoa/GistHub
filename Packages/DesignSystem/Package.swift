// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/elai950/AlertToast", from: "1.3.9"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.8.1")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                "AlertToast",
                "Kingfisher"
            ]
        )
    ]
)
