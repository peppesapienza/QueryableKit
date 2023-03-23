import XCTest
@testable import Queryable

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

struct SomeMapper: PredicateMapper {
    typealias MapRes = String
    typealias Context = String
    
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Context) throws -> String {
        "\(try predicate.field()) \(predicate.operator.rawValue) \(predicate.value)"
    }
    
    func map<Model, Value>(_ predicate: Order<Model, Value>, in context: inout String) throws -> String {
        "orderBy \(try predicate.field()) descending: \(predicate.descending)"
    }
}

final class QueryableTests: XCTestCase {
    func test_givenFieldHasBeenSpecified_then_fieldMethod_mustReturnsExpectedValue() throws {
        XCTAssertEqual(try Where(\City.name, equalTo: "").field(), "name")
        XCTAssertEqual(try Where(\City.population, equalTo: 0).field(), "populationCount")
    }
    
    func test_givenMissingPath_then_fieldMethod_mustThrownException() throws {
        XCTAssertThrowsError(try Where(\City.missingField, equalTo: false).field()) { error in
            print(error.localizedDescription)
            let error = try! XCTUnwrap(error as? FieldMissing<City>)
            XCTAssertEqual(error.key, \.missingField)
        }
    }
    
    func test_givenWherePredicates_testMapper_mustReturnsExpectedValue() throws {
        let someMapper = SomeMapper()
        
        var context = ""
        
        XCTAssertEqual(try Where(\City.name, equalTo: "someName").map(using: someMapper, in: &context), "name equalTo someName")
        XCTAssertEqual(try Where(\City.population, isGreaterThanOrEqualTo: 0).map(using: someMapper, in: &context), "populationCount isGreaterThanOrEqualTo 0")
        XCTAssertEqual(try Where(\City.suburbs, contains: "Melbourne").map(using: someMapper, in: &context), "suburbs contains Melbourne")
        XCTAssertEqual(try Where(\City.suburbs, isAnyOf: ["Melbourne"]).map(using: someMapper, in: &context), "suburbs isAnyOf [\"Melbourne\"]")
        XCTAssertEqual(try Order(by: \City.name).map(using: someMapper, in: &context), "orderBy name descending: true")
     
    }
}
