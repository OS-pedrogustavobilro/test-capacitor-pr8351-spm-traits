// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OspedrobilroCapPluginWithTraits",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "OspedrobilroCapPluginWithTraits",
            targets: ["PluginWithTraitsPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "PluginWithTraitsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/PluginWithTraitsPlugin"),
        .testTarget(
            name: "PluginWithTraitsPluginTests",
            dependencies: ["PluginWithTraitsPlugin"],
            path: "ios/Tests/PluginWithTraitsPluginTests")
    ]
)
