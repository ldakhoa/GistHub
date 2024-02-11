// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GistHub",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .singleTargetLibrary("AppAccount"),
        .singleTargetLibrary("DesignSystem"),
        .singleTargetLibrary("Editor"),
        .singleTargetLibrary("Environment"),
        .singleTargetLibrary("Gist"),
        .singleTargetLibrary("Home"),
        .singleTargetLibrary("Login"),
        .singleTargetLibrary("Markdown"),
        .singleTargetLibrary("Models"),
        .singleTargetLibrary("Networking"),
        .singleTargetLibrary("Profile"),
        .singleTargetLibrary("Settings"),
        .singleTargetLibrary("Search"),
        .singleTargetLibrary("Utilities")
    ],
    dependencies: [
        .package(url: "https://github.com/elai950/AlertToast", from: "1.3.9"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.8.1"),
        .package(url: "https://github.com/evgenyneu/keychain-swift", branch: "master"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.4")),
        .package(url: "https://github.com/simonbs/Runestone", .upToNextMajor(from: "0.3.2")),
        .package(url: "https://github.com/simonbs/KeyboardToolbar", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/simonbs/treesitterlanguages", from: "0.1.0"),
        .package(url: "https://github.com/ldakhoa/StyledTextKit", from: "1.0.0"),
        .package(url: "https://github.com/ldakhoa/gisthub-cmark-gfm-swift", from: "1.0.2"),
        .package(url: "https://github.com/ldakhoa/Highlightr", from: "1.0.2"),
        .package(url: "https://github.com/alexaubry/HTMLString", from: "6.0.0"),
        .package(url: "https://github.com/duytph/Networkable", from: "2.0.0"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.3.2"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.3.0")
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

        .target(
            name: "DesignSystem",
            dependencies: [
                "AlertToast",
                "Kingfisher"
            ]
        ),

        .target(
            name: "Editor",
            dependencies: [
                "Runestone",
                "Models",
                "Networking",
                "Environment",
                "Utilities",
                "KeyboardToolbar",
                "Markdown"
            ]
        ),

        .target(
            name: "Environment",
            dependencies: [
                "Runestone",
                "Networking",
                "Utilities"
            ]
        ),

        .target(
            name: "Gist",
            dependencies: [
                "Models",
                "DesignSystem",
                "Networking",
                "Markdown",
                "Environment",
                "Utilities",
                "Comment",
                "Editor",
                .product(name: "Collections", package: "swift-collections"),
                "Inject"
            ]
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

        .target(
            name: "Home",
            dependencies: [
                "AppAccount",
                "DesignSystem",
                "Environment",
                "Utilities",
                "Gist"
            ]
        ),

        .target(
            name: "Login",
            dependencies: [
                "DesignSystem",
                "Networking",
                "AppAccount",
                "Utilities",
                "Environment"
            ]
        ),

        .target(
            name: "Markdown",
            dependencies: [
                "StyledTextKit",
                .product(name: "cmark-gfm-swift", package: "gisthub-cmark-gfm-swift"),
                "HTMLString",
                "DesignSystem",
                "Models",
                "Environment",
                "Highlightr",
                "Kingfisher"
            ]
        ),

        .target(
            name: "Models",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "TreeSitterAstroRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterBashRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterCRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterCPPRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterCSharpRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterCSSRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterElixirRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterElmRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterGoRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterHaskellRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterHTMLRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJavaRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJavaScriptRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJSDocRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJSONRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJSON5Runestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterJuliaRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterLaTeXRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterLuaRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterMarkdownRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterOCamlRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterPerlRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterPHPRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterPythonRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterRRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterRegexRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterRubyRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterRustRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterSCSSRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterSvelteRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterSwiftRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterTOMLRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterTSXRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterTypeScriptRunestone", package: "treesitterlanguages"),
                .product(name: "TreeSitterYAMLRunestone", package: "treesitterlanguages"),
                "Runestone",
                "Utilities"
            ]
        ),

        .target(
            name: "Networking",
            dependencies: [
                "Models",
                "Networkable",
                "AppAccount",
                "GistHubGraphQL",
                .product(name: "Apollo", package: "apollo-ios")
            ]
        ),
        .target(
            name: "GistHubGraphQL",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios")
            ]
        ),

        .target(
            name: "Profile",
            dependencies: [
                "Networking",
                "Models",
                "Settings",
                "DesignSystem"
            ]
        ),

        .target(
            name: "Settings",
            dependencies: [
                "Networking",
                "Models",
                "AppAccount",
                "DesignSystem",
                "Editor",
                "Utilities"
            ]
        ),

        .target(
            name: "Search",
            dependencies: [
                "DesignSystem",
                "Environment",
                "Models",
                "Networking",
                "Gist",
                "Profile"
            ]
        ),

        .target(
            name: "Utilities",
            dependencies: [
                "DesignSystem",
                "AlertToast"
            ]
        ),
    ]
)

extension Product {
    /// Creates a library product to allow clients that declare a dependency on this package to use the package’s functionality.
    /// - Parameter name: The name of the library product.
    /// - Returns: A Product instance.
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, type: .static, targets: [name])
    }
}
