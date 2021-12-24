// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "QACPercentageSurvey",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", "5.2.7"..<"5.3.0")
    ],
    targets: [
        .target(
            name: "AppModule",
            dependencies: [.product(name: "Kanna", package: "Kanna")]
        ),
        .executableTarget(
            name: "1-StoreCalendarsData",
            dependencies: ["AppModule"],
            swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        ),
        .executableTarget(
            name: "2-StoreArticlesData",
            dependencies: ["AppModule"],
            swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        ),
        .executableTarget(
            name: "3-AggregateHostPercentages",
            dependencies: ["AppModule"],
            swiftSettings: [.unsafeFlags(["-warn-concurrency"])]
        ),
    ]
)
