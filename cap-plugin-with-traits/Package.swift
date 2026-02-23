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
            enabledTraits: ["DebugLogging"]
        ),
        .trait(
            name: "Analytics",
            description: "Enable analytics and telemetry features",
            enabledTraits: []
        ),
        .trait(
            name: "Performance",
            description: "Enable performance optimizations and monitoring",
            enabledTraits: []
        ),
        .default(enabledTraits: ["PrivacyManifest"])
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
                // Simple trait conditionals
                .define("DEBUG_LOGGING", .when(traits: ["DebugLogging"])),
                .define("PRIVACY_MANIFEST", .when(traits: ["PrivacyManifest"])),
                .define("EXTENDED_FEATURES", .when(traits: ["ExtendedFeatures"])),
                .define("ANALYTICS_ENABLED", .when(traits: ["Analytics"])),

                // Performance optimization flags
                .define("PERFORMANCE_MONITORING", .when(traits: ["Performance"])),
                .unsafeFlags(["-O"], .when(traits: ["Performance"])),

                // Combined trait conditions (multiple traits)
                .define("FULL_FEATURE_SET", .when(traits: ["ExtendedFeatures", "Analytics"])),

                // Platform + trait conditions
                .define("IOS_PRIVACY_TRACKING", .when(platforms: [.iOS], traits: ["PrivacyManifest"])),

                // Configuration-based conditionals
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE_BUILD", .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "PluginWithTraitsPluginTests",
            dependencies: ["PluginWithTraitsPlugin"],
            path: "ios/Tests/PluginWithTraitsPluginTests",
            swiftSettings: [
                // Enable assertions in tests when DebugLogging trait is active
                .define("ENABLE_TEST_ASSERTIONS", .when(traits: ["DebugLogging"]))
            ]
        )
    ]
)
