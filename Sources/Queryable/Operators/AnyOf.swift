public struct AnyOf<Model: Queryable, Value: Codable>: Predicate {
    public let key: PartialKeyPath<Model>
    public let value: [Value]
    
    public init(_ value: [Value], in key: KeyPath<Model, Value>) {
        self.key = key
        self.value = value
    }
    
    public func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper : PredicateMapper {
        throw NotImplemented()
    }
}
