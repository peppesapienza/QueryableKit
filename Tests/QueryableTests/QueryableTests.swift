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
    
    func map<Model, Value>(_ predicate: IsEqual<Model, Value>, in context: inout Context) throws -> String {
        "\(try predicate.field()) equalTo \(predicate.value)"
    }
    
    func map<Model, Value>(_ predicate: Compare<Model, Value>, in context: inout Context) throws -> String {
        "\(try predicate.field()) \(predicate.operator.rawValue) \(predicate.value)"
    }
    
    func map<Model, Value>(_ predicate: Order<Model, Value>, in context: inout String) throws -> String {
        "orderBy \(try predicate.field()) descending: \(predicate.descending)"
    }
    
    func map<Model, Value>(_ predicate: Contains<Model, Value>, in context: inout String) throws -> String {
        "\(predicate.operator.rawValue) \(predicate.value) in \(try predicate.field())"
    }
}

final class QueryableTests: XCTestCase {
    func test_givenFieldHasBeenSpecified_then_fieldMethod_mustReturnsExpectedValue() throws {
        XCTAssertEqual(try IsEqual(\City.name, to: "").field(), "name")
        XCTAssertEqual(try IsEqual(\City.population, to: 0).field(), "populationCount")
    }
    
    func test_givenMissingPath_then_fieldMethod_mustThrownException() throws {
        XCTAssertThrowsError(try IsEqual(\City.missingField, to: false).field()) { error in
            print(error.localizedDescription)
            let error = try! XCTUnwrap(error as? FieldMissing<City>)
            XCTAssertEqual(error.key, \.missingField)
        }
    }
    
    func test_givenWherePredicates_testMapper_mustReturnsExpectedValue() throws {
        let someMapper = SomeMapper()
        
        var context = ""
        
        XCTAssertEqual(try IsEqual(\City.name, to: "someName").map(using: someMapper, in: &context), "name equalTo someName")
        XCTAssertEqual(try Compare(\City.population, isGreaterThanOrEqualTo: 0).map(using: someMapper, in: &context), "populationCount isGreaterThanOrEqualTo 0")
        XCTAssertEqual(try Contains("Melbourne", in: \City.suburbs).map(using: someMapper, in: &context), "contains [\"Melbourne\"] in suburbs")
        XCTAssertEqual(try Contains(anyOf: ["Melbourne"], in: \City.suburbs).map(using: someMapper, in: &context), "anyOf [\"Melbourne\"] in suburbs")
        XCTAssertEqual(try Order(by: \City.name).map(using: someMapper, in: &context), "orderBy name descending: true")
     
        let inMem = InMemoryPredicateMapper<City>()
        
        var array = [
            City(name: "Rome", population: 10, suburbs: ["1"]),
            City(name: "Melbourne", population: 100, suburbs: ["2"])
        ]
        
        try [
            Compare(\City.population, isGreaterThan: 10)
        ].forEach { predicate in
            try inMem.map(predicate, in: &array)
        }
        
        print(array)
    }
}


struct InMemoryPredicateMapper<Element>: PredicateMapper {
    
    func map<Model, Value>(_ predicate: IsEqual<Model, Value>, in context: inout [Element]) throws {
        context = context.filter { predicate.isSatisfied(by: ($0 as! Model)[keyPath: predicate.keyPath]) }
    }
    
    func map<Model, Value>(_ predicate: Compare<Model, Value>, in context: inout [Element]) throws {
        switch predicate.operator {
        case .isGreaterThan:
            context = context.filter { predicate.isSatisfied(by: ($0 as! Model)[keyPath: predicate.keyPath]) }
            
        case .isGreaterThanOrEqualTo:
            context = context.filter { predicate.isSatisfied(by: ($0 as! Model)[keyPath: predicate.keyPath]) }
            
        case .isLessThan:
            context = context.filter { predicate.isSatisfied(by: ($0 as! Model)[keyPath: predicate.keyPath]) }
            
        case .isLessThanOrEqualTo:
            context = context.filter { predicate.isSatisfied(by: ($0 as! Model)[keyPath: predicate.keyPath]) }
        }
    }
    
    func map<Model, Value>(_ predicate: Order<Model, Value>, in context: inout [Element]) throws {
    }
    
    func map<Model, Value>(_ predicate: Contains<Model, Value>, in context: inout [Element]) throws {
    }
    
}
