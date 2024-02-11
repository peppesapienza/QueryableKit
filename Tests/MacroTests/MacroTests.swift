import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import QueryableMacros

let testMacros: [String: Macro.Type] = [
    "Queryable": QueryableMacro.self,
]

let backslash = QueryableMacro.backslashToken

final class QueryableMacroTests: XCTestCase {
    
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
    
    func test_givenModelImplementsCustomCodingKey_onlyDefinedPropertiesMustBeAddedInField() throws {
        assertMacroExpansion(
            """
            @Queryable
            struct City: Equatable {
                let name: String
                let population: Int
                let suburbs: [String]
            
                let mustNotBeMapped: Bool = false
            
                enum CodingKeys: String, CodingKey {
                    case name
                    case population = "populationCount"
                    case suburbs
                }
            }
            """,
            expandedSource: """
            struct City: Equatable {
                let name: String
                let population: Int
                let suburbs: [String]
            
                let mustNotBeMapped: Bool = false
            
                enum CodingKeys: String, CodingKey {
                    case name
                    case population = "populationCount"
                    case suburbs
                }

                static func field(_ path: PartialKeyPath<Self>) -> String? {
                    switch path {
                    case \(backslash).name:
                        return CodingKeys.name.stringValue
                    case \(backslash).population:
                        return CodingKeys.population.stringValue
                    case \(backslash).suburbs:
                        return CodingKeys.suburbs.stringValue
                    default:
                        return nil
                    }
                }
            }
            
            extension City: QueryableModel {
            }
            """,
            macros: testMacros
        )
    }

}

