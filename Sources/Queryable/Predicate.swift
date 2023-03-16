public protocol Predicate<Model, Value> where Model: Queryable {
    associatedtype Model
    associatedtype Value
    
    var key: PartialKeyPath<Model> { get }
    var value: Value { get }
    
    func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes
}

struct NotImplemented: Error {}

extension Predicate {
    var type: Model.Type { Model.self }
    
    public func field() -> String? {
        Model.field(key)
    }
    
    public func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes {
        throw NotImplemented()
    }
}
