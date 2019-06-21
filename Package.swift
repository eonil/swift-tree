// swift-tools-version:4.0
// https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescriptionV4.md

import PackageDescription

let package = Package(
    name: "Tree",
    products: [
        .library(name: "Tree", targets: ["Tree"]),
    ],
    targets: [
        .target(
            name: "Tree",
            path: "Tree"),
        .testTarget(
            name: "TreeTest",
            dependencies: ["Tree"],
            path: "TreeTest"),
    ]
)
