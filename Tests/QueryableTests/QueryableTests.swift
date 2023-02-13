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

final class QueryableTests: XCTestCase {
    
    func pathShouldBeConvertedWhenExists() throws {
        XCTAssertEqual(Where(\City.name, equalTo: "").field(), "name")
        XCTAssertEqual(Where(\City.population, equalTo: 0).field(), "populationCount")
    }
}
