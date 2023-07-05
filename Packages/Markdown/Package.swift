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
    ],
    targets: [
        .target(
            name: "Markdown",
            dependencies: [
                "StyledTextKit"
            ]
        ),
        .testTarget(
            name: "MarkdownTests",
            dependencies: ["Markdown"]
        ),
    ]
)
