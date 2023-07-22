// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gpl_api_generator",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "gpl_api_generator", targets: ["gpl_api_generator"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMinor(from: "1.1.4")
        ),
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .executableTarget(
            name: "gpl_api_generator",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"),
                .product(
                    name: "ApolloCodegenLib",
                    package: "apollo-ios")
            ]
        ),
        .testTarget(
            name: "gpl_api_generatorTests",
            dependencies: ["gpl_api_generator"]),
    ]
)
