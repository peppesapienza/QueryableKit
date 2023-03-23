public protocol PredicateMapper {
    associatedtype MapRes
    associatedtype Context
    
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Context) throws -> MapRes
    func map<Model, Value>(_ predicate: Contains<Model, Value>, in context: inout Context) throws -> MapRes
    func map<Model, Value>(_ predicate: Order<Model, Value>, in context: inout Context) throws -> MapRes
}

