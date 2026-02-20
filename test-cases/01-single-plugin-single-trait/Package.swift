// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "TestApp",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "TestApp",
            targets: ["TestApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        .package(url: "https://github.com/ionic-team/capacitor-status-bar.git", from: "8.0.0", traits: ["PrivacyManifest"]),
        .package(url: "https://github.com/ionic-team/capacitor-app.git", from: "8.0.0"),
        .package(url: "https://github.com/ionic-team/capacitor-haptics.git", from: "8.0.0"),
        .package(url: "https://github.com/ionic-team/capacitor-keyboard.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "TestApp",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "CapacitorStatusBar", package: "capacitor-status-bar"),
                .product(name: "CapacitorApp", package: "capacitor-app"),
                .product(name: "CapacitorHaptics", package: "capacitor-haptics"),
                .product(name: "CapacitorKeyboard", package: "capacitor-keyboard")
            ],
            path: "Sources")
    ]
)
