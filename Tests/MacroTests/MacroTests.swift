import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(QueryableMacro)
@testable import QueryableMacros

let testMacros: [String: Macro.Type] = [
    "Queryable": QueryableMacro.self,
]
#endif

final class MyMacroTests: XCTestCase {
    func testExpansionProcudesExpectedOutput() throws {
#if canImport(QueryableMacro)
        assertMacroExpansion(
            """
            @Queryable
            struct Some: Codable {
                let age: Int
                let firstName: String
            }
            """,
            expandedSource: """
            struct Some: Codable {
                let age: Int
                let firstName: String
            
                static func field(_ path: PartialKeyPath<Self>) -> String? {
                    switch path {
                    case \(QueryableMacro.backslashToken).age:
                        return CodingKeys.age.stringValue
                    case \(QueryableMacro.backslashToken).firstName:
                        return CodingKeys.firstName.stringValue
                    default:
                        return nil
                    }
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

}

