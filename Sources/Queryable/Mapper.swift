public protocol PredicateMapper {
    associatedtype MapRes
    
    func map<Model, Value>(_ value: Where<Model, Value>) throws -> MapRes
}

