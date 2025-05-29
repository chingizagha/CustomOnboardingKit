// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "OnboardingFlow",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "OnboardingFlow",
            targets: ["OnboardingFlow"]),
    ],
    targets: [
        .target(
            name: "OnboardingFlow"),

    ]
)

