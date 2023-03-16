// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Queryable",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Queryable",
            targets: ["Queryable"]),
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
            name: "Queryable",
            dependencies: []),
        .target(
            name: "FirestoreQueryable",
            dependencies: [
                "Queryable",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
            ],
            linkerSettings: [
                .linkedLibrary("c++"),
            ]
        ),
        .testTarget(
            name: "QueryableTests",
            dependencies: ["Queryable"]
        ),
        .testTarget(
            name: "FirestoreQueryableTests",
            dependencies: ["FirestoreQueryable"]
        ),
    ]
)
