// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2022",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "AOC2022Lib",
            targets: ["AOC2022Lib"]
        ),
        .executable(
            name: "aoc2022",
            targets: ["Runtime"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-parsing.git",
            from: "0.10.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump.git",
            from: "0.6.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-overture.git",
            from: "0.5.0"
        )
    ],
    targets: [
        .target(
            name: "AOC2022Lib",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Overture", package: "swift-overture"),
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
        .executableTarget(
            name: "Runtime",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AOC2022Lib"
            ]
        ),
        .testTarget(
            name: "AOC2022Tests",
            dependencies: [
                "AOC2022Lib",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
    ]
)
