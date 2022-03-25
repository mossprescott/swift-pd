// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-pd",
    products: [
        .library(name: "Playdate", targets: ["Playdate"]),
    ],
    targets: [
        .systemLibrary(
            name: "CPlaydate"
        ),
        .target(
            name: "Playdate",
            dependencies: ["CPlaydate"]
        ),
    ]
)