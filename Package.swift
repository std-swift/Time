// swift-tools-version:5.0
//
//  Package.swift
//  Time
//

import PackageDescription

let package = Package(
	name: "Time",
	platforms: [
		.macOS(.v10_12)
	],
	products: [
		.library(
			name: "Time",
			targets: ["Time"]),
	],
	targets: [
		.target(
			name: "Time",
			dependencies: []),
		.testTarget(
			name: "TimeTests",
			dependencies: ["Time"]),
	]
)
