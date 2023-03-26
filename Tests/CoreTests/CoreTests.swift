import XCTest
@testable import QueryableCore

struct City: Queryable {
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

final class QueryableTests: XCTestCase {
    func test_givenFieldHasBeenSpecified_then_fieldMethod_mustReturnsExpectedValue() throws {
        XCTAssertEqual(try Field(\City.name, isEqualTo: "").field(), "name")
        XCTAssertEqual(try Field(\City.population, isGreaterThanOrEqualTo: 0).field(), "populationCount")
    }
    
    func test_givenMissingPath_then_fieldMethod_mustThrownException() throws {
        XCTAssertThrowsError(try Field(\City.missingField, isEqualTo: false).field()) { error in
            print(error.localizedDescription)
            let error = try! XCTUnwrap(error as? FieldMissing<City>)
            XCTAssertEqual(error.key, \.missingField)
        }
    }
}
