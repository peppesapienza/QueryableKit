import XCTest
@testable import QueryableCore

struct City: QueryableModel, Equatable {
    let name: String
    let population: Int
    let suburbs: [String]
    
    let missingField: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case population = "populationCount"
        case suburbs
    }
    
    static func field(_ path: PartialKeyPath<City>) -> String? {
        switch path {
        case \.name: return CodingKeys.name.stringValue
        case \.population: return CodingKeys.population.stringValue
        case \.suburbs: return CodingKeys.suburbs.stringValue
        default: return nil
        }
    }
}

@Queryable
struct Person {
    let name: String
    let age: Int
    let friendsIds: [Int]
}

final class QueryableTests: XCTestCase {
    func test_whenFieldExists_mustReturnExpectedName() throws {
        XCTAssertEqual(try Field(\City.name, isEqualTo: "").field(), "name")
        XCTAssertEqual(try Field(\City.population, isGreaterThanOrEqualTo: 0).field(), "populationCount")
        
        XCTAssertEqual(try Field(\Person.name, isEqualTo: "").field(), "name")
        XCTAssertEqual(try Field(\Person.age, isEqualTo: 0).field(), "age")
        XCTAssertEqual(try Field(\Person.friendsIds, contains: 0).field(), "friendsIds")
    }
    
    func test_whenFieldIsMissing_mustThrow_FieldMissing() throws {
        XCTAssertThrowsError(try Field(\City.missingField, isEqualTo: false).field()) { error in
            print(error.localizedDescription)
            let error = try! XCTUnwrap(error as? FieldMissing<City>)
            XCTAssertEqual(error.key, \.missingField)
        }
    }
}
