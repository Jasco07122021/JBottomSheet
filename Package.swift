// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JBottomSheet",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "JBottomSheet",
            targets: ["JBottomSheet"]
        ),
    ],
    dependencies: [
           .package(
               url: "https://github.com/perimeter-inc/LegacyScrollView",
               from: "2.1.0"
           )
       ],
    targets: [
        .target(
            name: "JBottomSheet",
            dependencies: ["LegacyScrollView"]
        ),
    ]
)
