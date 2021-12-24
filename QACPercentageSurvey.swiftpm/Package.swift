// swift-tools-version: 5.5

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "QACPercentageSurveyApp",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "QACPercentageSurveyApp",
            targets: ["AppModule"],
            bundleIdentifier: "jp.tret.qacpercentagesurvey",
            teamIdentifier: "9TWATL5SE8",
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", "5.2.7"..<"5.3.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "Kanna", package: "Kanna")
            ],
            path: "." // ,
            // swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        )
    ]
)