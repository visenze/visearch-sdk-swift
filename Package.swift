// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ViSearchSDK",
	platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "ViSearchSDK",
            targets: ["ViSearchSDK"]
		),
    ],
	dependencies: [
		.package(url: "https://github.com/csanfilippo/visenze-tracking-swift", .upToNextMajor(from: "0.2.1"))
	],
    targets: [
        .target(
            name: "ViSearchSDK",
			dependencies: [
				.product(name: "ViSenzeAnalytics", package: "visenze-tracking-swift")
			],
			path: "ViSearchSDK/ViSearchSDK/Classes",
			exclude: ["ViSearchSDKTests"]
		),
    ]
)
