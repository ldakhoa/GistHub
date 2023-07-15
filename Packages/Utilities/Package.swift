// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        )
    ],
    dependencies: [
        .package(name: "DesignSystem", path: "../DesignSystem"),
        .package(url: "https://github.com/elai950/AlertToast", from: "1.3.9")
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [
                "DesignSystem",
                "AlertToast"
            ]
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        )
    ]
)
