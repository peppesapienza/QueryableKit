// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

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
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: .init(10, 14, 0)),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.1.1")
    ],
    targets: [
        .target(
            name: "QueryableCore",
            dependencies: ["QueryableMacros"],
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

        // MARK: Macro
        .macro(
            name: "QueryableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/Macro"
        ),
        
        // MARK: Tests
        .testTarget(
            name: "CoreTests",
            dependencies: ["QueryableCore"]
        ),
        .testTarget(
            name: "FirestoreTests",
            dependencies: ["FirestoreQueryable"],
            resources: [.copy("secrets/secrets.json")]
        ),
        .testTarget(
            name: "MacroTests",
            dependencies: [
                "QueryableMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
