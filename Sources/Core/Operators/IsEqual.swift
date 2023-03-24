public struct IsEqual<Model: Queryable, Value: Equatable>: Predicate {
    public var key: PartialKeyPath<Model> { keyPath }
    public let value: Value
    
    public let keyPath: KeyPath<Model, Value>

    public init(_ key: KeyPath<Model, Value>, to value: Value) {
        self.value = value
        self.keyPath = key
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        try mapper.map(self, in: &context)
    }
    
    func isSatisfied(by candidate: Value) -> Bool {
        value == candidate
    }
}

public func ==<Model: Queryable, Value: Equatable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    IsEqual(lhs, to: rhs)
}
