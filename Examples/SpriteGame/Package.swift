// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "SpriteGame",
  products: [
    .library(
      name: "SpriteGame",
      type: .dynamic,
      targets: ["SpriteGame"]
    ),
  ],
  dependencies: [
    .package(name: "swift-pd", path: "../../swift")
  ],
  targets: [
    .target(
      name: "SpriteGame",
      dependencies: [
        .product(name: "Playdate", package: "swift-pd")
      ]
    )
  ]
)
