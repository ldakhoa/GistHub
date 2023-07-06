// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Gist",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Gist",
            targets: ["Gist"]
        ),
        .library(
            name: "Comment",
            targets: ["Comment"]
        ),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(name: "Networking", path: "../Networking"),
        .package(name: "Markdown", path: "../Markdown"),
        .package(name: "Environment", path: "../Environment"),
        .package(name: "Utilities", path: "../Utilities"),
        .package(name: "Editor", path: "../Editor"),
    ],
    targets: [
        .target(
            name: "Gist",
            dependencies: [
                "Models",
                "DesignSystem",
                "Networking",
                "Markdown",
                "Environment",
                "Utilities",
                "Comment"
            ]
        ),
        .testTarget(
            name: "GistTests",
            dependencies: ["Gist"]
        ),
        .target(
            name: "Comment",
            dependencies: [
                "Models",
                "DesignSystem",
                "Networking",
                "Markdown",
                "Environment",
                "Utilities",
                "Editor"
            ]
        ),
    ]
)
