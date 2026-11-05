// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "KusuriCore",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "KusuriCore", targets: ["KusuriCore"])
    ],
    targets: [
        .target(name: "KusuriCore")
    ]
)
