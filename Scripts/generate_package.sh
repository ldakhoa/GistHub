#!/bin/bash

# Args
if [ "$#" -lt 1 ]; then
    echo "Please provide a package name."
    exit 0
fi

packageName=$1

echo "🔨 Starting to generate $packageName..."

rootDir=$(pwd)
packageDir="$rootDir/Packages/$packageName"

mkdir -p "$packageDir"

packageContents=$(cat <<EOF
// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "$packageName",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "$packageName",
            targets: ["$packageName"]
        )
    ],
    dependencies: [
        // Local package dependencies
        // .package(name: "Package name", path: "../Package name")
        // Third package dependencies
        // .package(url: "url", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "$packageName",
            dependencies: []
        ),
        .testTarget(
            name: "${packageName}Tests",
            dependencies: ["$packageName"]
        )
    ]
)
EOF
)

gitIgnoreContents=$(cat <<EOF
.DS_Store
/.build
/Packages
xcuserdata/
DerivedData/
.netrc
.swiftpm/
EOF
)

echo "$packageContents" > "$packageDir/Package.swift"
echo "$gitIgnoreContents" > "$packageDir/.gitignore"

sourceDir="$packageDir/Sources/$packageName"
testDir="$packageDir/Tests/${packageName}Tests"
mkdir -p "$sourceDir"
mkdir -p "$testDir"

touch "$sourceDir/$packageName.swift"
touch "$testDir/${packageName}Tests.swift"

echo "🔄 Resolving package..."
# Change directory and resolve package
cd "$packageDir" && swift package resolve

if [ $? -eq 0 ]; then
    echo "️✅ Generated $packageName."
else
    echo "❌ Failed to resolve package."
fi