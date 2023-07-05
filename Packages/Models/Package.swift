// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.4")
        ),
        .package(
            url: "https://github.com/simonbs/treesitterlanguages",
            from: "0.1.0"
        ),
        .package(
            url: "https://github.com/simonbs/Runestone",
            .upToNextMajor(from: "0.2.9")
        )
    ],
    targets: [
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
                "Runestone"
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["Models"]
        ),
    ]
)
