// swift-tools-version:4.0
// https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescriptionV4.md

import PackageDescription

let package = Package(
    name: "Tree",
    products: [
        .library(name: "Tree", targets: ["Tree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/eonil/BTree", .branch("master")),
    ],
    targets: [
        .target(
            name: "Tree",
            dependencies: ["BTree"],
            path: "Tree"),
        .testTarget(
            name: "TreeTest",
            dependencies: ["Tree", "BTree"],
            path: "TreeTest"),
    ]
)
