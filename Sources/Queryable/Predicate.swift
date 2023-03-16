public protocol Predicate<Model, Value> where Model: Queryable {
    associatedtype Model
    associatedtype Value
    
    var key: PartialKeyPath<Model> { get }
    var value: Value { get }
    
    func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes
}

extension Predicate {
    var type: Model.Type { Model.self }
    
    public func field() throws -> String {
        guard let field = Model.field(key) else {
            throw FieldMissing(key: key)
        }
        
        return field
    }
    
    public func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes {
        throw NotImplemented()
    }
}
