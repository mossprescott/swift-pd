// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "HelloWorld",
  products: [
    .library(
      name: "HelloWorld",
      type: .dynamic,
      targets: ["HelloWorld"]
    ),
  ],
  dependencies: [
    .package(name: "swift-pd", path: "../../swift-pd")
  ],
  targets: [
    .target(
      name: "HelloWorld",
      dependencies: [
        .product(name: "Playdate", package: "swift-pd")
      ]
    )
  ]
)
