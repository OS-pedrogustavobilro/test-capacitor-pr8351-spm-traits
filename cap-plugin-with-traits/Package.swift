// swift-tools-version: 6.1
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
            path: "ios/Sources/PluginWithTraitsPlugin",
            swiftSettings: [
                .define("DEBUG_LOGGING", .when(traits: ["DebugLogging"])),
                .define("PRIVACY_MANIFEST", .when(traits: ["PrivacyManifest"])),
                .define("EXTENDED_FEATURES", .when(traits: ["ExtendedFeatures"]))
            ]
        ),
        .testTarget(
            name: "PluginWithTraitsPluginTests",
            dependencies: ["PluginWithTraitsPlugin"],
            path: "ios/Tests/PluginWithTraitsPluginTests")
    ],
    traits: [
        .trait(
            name: "DebugLogging",
            description: "Enable verbose debug logging for development",
            enabledTraits: []
        ),
        .trait(
            name: "PrivacyManifest",
            description: "Include privacy-focused tracking and compliance features",
            enabledTraits: []
        ),
        .trait(
            name: "ExtendedFeatures",
            description: "Enable extended plugin features and functionality",
            enabledTraits: []
        )
    ]
)
