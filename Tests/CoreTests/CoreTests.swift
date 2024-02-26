import XCTest
@testable import QueryableCore

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
        XCTAssertThrowsError(try Field(\City.mustNotBeMapped, isEqualTo: false).field()) { error in
            print(error.localizedDescription)
            let error = try! XCTUnwrap(error as? FieldMissing<City>)
            XCTAssertEqual(error.key, \.mustNotBeMapped)
        }
    }
    
    func test_fieldOverloads_produceExpectedOperator() throws {
        XCTAssertEqual((\City.name == "").operator, .isEqualTo)
        XCTAssertEqual((\City.population > 0).operator, .isGreaterThan)
        XCTAssertEqual((\City.population >= 0).operator, .isGreaterThanOrEqualTo)
        XCTAssertEqual((\City.population < 0).operator, .isLessThan)
        XCTAssertEqual((\City.population <= 0).operator, .isLessThanOrEqualTo)
    }
    
}
