// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ViSenzeAnalytics",
	platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "ViSenzeAnalytics",
            targets: ["ViSenzeAnalytics"]),
    ],
    targets: [
        .target(
            name: "ViSenzeAnalytics",
			dependencies: [],
			path: "ViSenzeAnalytics/ViSenzeAnalytics/Classes",
			exclude: ["ViSenzeAnalyticsTests"]
		),
    ]
)
