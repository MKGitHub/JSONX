// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name:"JSONX",
    products:[
        .library(name:"JSONX", targets:["JSONX"])
    ],
    targets:[
        .target(name:"JSONX", dependencies:[])
    ],
    swiftLanguageVersions:[4]
)

