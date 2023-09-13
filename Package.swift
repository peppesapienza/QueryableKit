// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "QueryableKit",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "QueryableCore",
            targets: ["QueryableCore"]),
        .library(
            name: "FirestoreQueryable",
            targets: ["FirestoreQueryable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: .init(10, 0, 0))
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
