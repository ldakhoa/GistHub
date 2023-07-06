// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Markdown",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Markdown",
            targets: ["Markdown"]
        ),
    ],
    dependencies: [
         .package(url: "https://github.com/ldakhoa/StyledTextKit", from: "1.0.0"),
         .package(url: "https://github.com/ldakhoa/gisthub-cmark-gfm-swift", from: "1.0.2"),
         .package(url: "https://github.com/alexaubry/HTMLString", from: "6.0.0"),
         .package(name: "DesignSystem", path: "../DesignSystem"),
         .package(name: "Models", path: "../Models"),
         .package(name: "Environment", path: "../Environment")
    ],
    targets: [
        .target(
            name: "Markdown",
            dependencies: [
                "StyledTextKit",
                .product(name: "cmark-gfm-swift", package: "gisthub-cmark-gfm-swift"),
                "HTMLString",
                "DesignSystem",
                "Models",
                "Environment"
            ]
        ),
        .testTarget(
            name: "MarkdownTests",
            dependencies: ["Markdown"]
        ),
    ]
)
