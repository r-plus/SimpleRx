// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleRx",
    products: [
        .library(
            name: "SimpleRx",
            targets: ["SimpleRx"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SimpleRx",
            dependencies: []),
        .testTarget(
            name: "SimpleRxTests",
            dependencies: ["SimpleRx"]),
    ]
)
