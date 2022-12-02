// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2022",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "AOC2022",
            targets: ["AOC2022"]
        ),
        .executable(
            name: "aoc2022",
            targets: ["Runtime"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "AOC2022",
            dependencies: []
        ),
        .executableTarget(
            name: "Runtime",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AOC2022"
            ]
        ),
        .testTarget(
            name: "AOC2022Tests",
            dependencies: ["AOC2022"]
        ),
    ]
)
