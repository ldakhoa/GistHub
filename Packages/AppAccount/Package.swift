// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "AppAccount",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "AppAccount",
            targets: ["AppAccount"]
        )
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(url: "https://github.com/evgenyneu/keychain-swift", branch: "master"),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.4")
        )
    ],
    targets: [
        .target(
            name: "AppAccount",
            dependencies: [
                "Models",
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "AppAccountTests",
            dependencies: ["AppAccount"]
        )
    ]
)
