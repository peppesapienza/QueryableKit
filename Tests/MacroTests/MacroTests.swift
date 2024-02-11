import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import QueryableMacros

let testMacros: [String: Macro.Type] = [
    "Queryable": QueryableMacro.self,
]

let backslash = QueryableMacro.backslashToken

final class MyMacroTests: XCTestCase {
    
    func test_givenModelWithNoCustomCodingKeys_allPropertiesMustBeAddedInField() throws {
        assertMacroExpansion(
            """
            @Queryable
            struct Some {
                let age: Int
                let firstName: String
                var isLoggedIn: Bool = false
            }
            """,
            expandedSource: """
            struct Some {
                let age: Int
                let firstName: String
                var isLoggedIn: Bool = false
            
                static func field(_ path: PartialKeyPath<Self>) -> String? {
                    switch path {
                    case \(backslash).age:
                        return CodingKeys.age.stringValue
                    case \(backslash).firstName:
                        return CodingKeys.firstName.stringValue
                    case \(backslash).isLoggedIn:
                        return CodingKeys.isLoggedIn.stringValue
                    default:
                        return nil
                    }
                }
            }
            
            extension Some: QueryableModel {
            }
            """,
            macros: testMacros
        )
    }

}

