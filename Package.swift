// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QueryableKit",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "QueryableCore",
            targets: ["QueryableCore"]),
        .library(
            name: "FirestoreQueryable",
            targets: ["FirestoreQueryable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", branch: "master")
    ],
    targets: [
        .target(
            name: "QueryableCore",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "FirestoreQueryable",
            dependencies: [
                "QueryableCore",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
            ],
            path: "Sources/Firestore",
            linkerSettings: [
                .linkedLibrary("c++"),
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["QueryableCore"]
        ),
        .testTarget(
            name: "FirestoreTests",
            dependencies: ["FirestoreQueryable"],
            resources: [.copy("secrets/secrets.json")]
        )
    ]
)
