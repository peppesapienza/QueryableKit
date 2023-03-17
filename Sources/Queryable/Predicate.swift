public protocol Predicate<Model, Value> where Model: Queryable {
    associatedtype Model
    associatedtype Value
    
    var key: PartialKeyPath<Model> { get }
    var value: Value { get }
    
    func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes
    func map<Mapper: PredicateMapper>(using mapper: Mapper, in context: inout Mapper.Context) throws
}

extension Predicate {
    var type: Model.Type { Model.self }
    
    public func field() throws -> String {
        guard let field = Model.field(key) else {
            throw FieldMissing(key: key)
        }
        
        return field
    }
    
    public func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        throw NotImplemented(missingIn: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper: PredicateMapper
        """)
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws where Mapper: PredicateMapper {
        throw NotImplemented(missingIn: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws where Mapper: PredicateMapper
        """)
    }
}
