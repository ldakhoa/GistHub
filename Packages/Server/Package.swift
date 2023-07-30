// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Server",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.1")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "Parser"
            ]
        ),
        .target(
            name: "Parser",
            dependencies: ["SwiftSoup"]
        ),
        .testTarget(
            name: "ParserTests",
            dependencies: [
                "SwiftSoup",
                "Parser"
            ]
        )
    ]
)
