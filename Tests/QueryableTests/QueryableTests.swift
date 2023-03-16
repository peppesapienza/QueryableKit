import XCTest
@testable import Queryable

struct City: Queryable {
    let name: String
    let population: Int
    
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
    
    func map<Model, Value>(_ value: Where<Model, Value>) throws -> String {
        "where"
    }
}

final class QueryableTests: XCTestCase {
    func test_givenFieldHasBeenSpecified_fieldMethod_shouldReturnsExpectedValue() throws {
        XCTAssertEqual(Where(\City.name, equalTo: "").field(), "name")
        XCTAssertEqual(Where(\City.population, equalTo: 0).field(), "populationCount")
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
