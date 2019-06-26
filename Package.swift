// swift-tools-version:5.0
// https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescription.md
import PackageDescription

let package = Package(
    name: "Tree",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .library(name: "Tree", type: .static, targets: ["Tree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/eonil/BTree", .branch("master")),
        .package(url: "https://github.com/eonil/swift-test-util", .branch("master")),
    ],
    targets: [
        .target(
            name: "Tree",
            dependencies: ["BTree"],
            path: "Tree"),
        .testTarget(
            name: "TreeTest",
            dependencies: ["Tree", "TestUtil"],
            path: "TreeTest"),
    ]
)
