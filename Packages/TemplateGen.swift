import Foundation

// Args
let args = CommandLine.arguments

// Check if package name is provided
guard args.count > 1 else {
    print("Please provide a package name.")
    exit(0)
}

let packageName = args[1]

print("🔨 Starting to generate \(packageName)...")

let fileManager = FileManager.default

let rootDir = fileManager.currentDirectoryPath
let packageDir = rootDir + "/Packages/\(packageName)"

try! fileManager.createDirectory(atPath: packageDir, withIntermediateDirectories: true, attributes: nil)

let packageContents = """
// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "\(packageName)",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "\(packageName)",
            targets: ["\(packageName)"]
        ),
    ],
    dependencies: [
        // Local package dependencies
        // .package(name: "Package name", path: "../Package name"),
        // Third package dependencies
        // .package(url: "url", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "\(packageName)",
            dependencies: []
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: ["\(packageName)"]
        ),
    ]
)

"""
let gitIgnoreContents = """
.DS_Store
/.build
/Packages
xcuserdata/
DerivedData/
.netrc
.swiftpm/
"""

try! packageContents.write(toFile: packageDir+"/Package.swift", atomically: true, encoding: String.Encoding.utf8)
try! gitIgnoreContents.write(toFile: packageDir+"/.gitignore", atomically: true, encoding: String.Encoding.utf8)

let sourceDir = packageDir + "/Sources/\(packageName)"
let testDir = packageDir + "/Tests/\(packageName)Tests"
try! fileManager.createDirectory(atPath: sourceDir, withIntermediateDirectories: true, attributes: nil)
try! fileManager.createDirectory(atPath: testDir, withIntermediateDirectories: true, attributes: nil)

try! "".write(toFile: sourceDir+"/\(packageName).swift", atomically: true, encoding: String.Encoding.utf8)
try! "".write(toFile: testDir+"/\(packageName)Tests.swift", atomically: true, encoding: String.Encoding.utf8)

print("🔄 Resolving package...")
// Change directory and resolve package
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
process.arguments = ["cd", packageDir, "&&", "swift", "package", "resolve"]
try! process.run()
process.waitUntilExit()

if process.terminationStatus == 0 {
    print("️✅ Generated \(packageName).")
} else {
    print("❌ Failed to resolve package.")
}