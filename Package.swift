// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeTheme",
    products: [
        .executable(name: "XcodeTheme", targets: ["XcodeTheme"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "XcodeTheme", dependencies: [
                    "Files", "ShellOut", .product(name: "ArgumentParser", package: "swift-argument-parser")
        ])
    ]
)
