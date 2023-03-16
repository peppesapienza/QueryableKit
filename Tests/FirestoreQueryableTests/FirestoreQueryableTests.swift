import XCTest
import Queryable
@testable import FirestoreQueryable

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

final class MapperTests: XCTestCase {
    
    func test_given() throws {
        let predicates: [any Predicate] = [
            Where(\City.name, equalTo: ""),
            Where(\City.population, equalTo: 0)
        ]
        
        let mapper = FirestoreMapper()
        
        try predicates.forEach { predicate in
            try predicate.map(using: mapper)
        }
    }
    
    
}
