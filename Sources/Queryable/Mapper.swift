public protocol PredicateMapper {
    associatedtype MapRes
    associatedtype Context
    
    func map<Model, Value>(_ predicate: Where<Model, Value>) throws -> MapRes
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Context) throws
}

