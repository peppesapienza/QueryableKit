import XCTest
@testable import Queryable

struct City: Queryable {
    let name: String
    let population: Int
    
    let missingField: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case population = "populationCount"
    }
    
    static func field(_ path: PartialKeyPath<City>) -> String? {
        switch path {
        case \.name: return CodingKeys.name.stringValue
        case \.population: return CodingKeys.population.stringValue
        default: return nil
        }
    }
}

struct SomeMapper: PredicateMapper {
    typealias MapRes = String
    typealias Context = String
    
    func map<Model, Value>(_ predicate: Where<Model, Value>) throws -> String {
        "where"
    }
    
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Context) throws {
        
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
    
    func test_some() throws {
        let predicates: [any Predicate] = [
            Where(\City.name, equalTo: ""),
            Where(\City.population, equalTo: 0)
        ]
        
        try predicates.forEach {
            print(try $0.map(using: SomeMapper()))
        }
    }
}
