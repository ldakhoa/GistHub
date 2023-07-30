// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
        .package(url: "https://github.com/ldakhoa/GistHub-HTML-Parser.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                "GistHub-HTML-Parser",
                .product(name: "Vapor", package: "vapor")
            ]
        )
    ]
)
