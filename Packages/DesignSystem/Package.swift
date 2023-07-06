// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/elai950/AlertToast", from: "1.3.9")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                "AlertToast"
            ]
        )
    ]
)
