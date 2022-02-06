// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pkg = Package(name: "PIASPM")

pkg.platforms = [
   .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v3)
]

pkg.products = [
   .library(name: "PIASPMShared", targets: ["PIASPMShared"])
]

pkg.targets = [
   .target(name: "PIASPMShared", dependencies: [], path: "Sources"),
   .target(name: "PIATestsShared", dependencies: ["PIASPMShared"], path: "Tests/Common"),
   .testTarget(name: "PIAFoundationTests", dependencies: ["PIASPMShared", "PIATestsShared"], path: "Tests/Foundation"),
   .testTarget(name: "PIARuntimeTests", dependencies: ["PIASPMShared", "PIATestsShared"], path: "Tests/Runtime"),
   .testTarget(name: "PIAUITests", dependencies: ["PIASPMShared", "PIATestsShared"], path: "Tests/UI")
]
