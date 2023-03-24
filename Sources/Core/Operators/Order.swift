public struct Order<Model: Queryable, Value: Comparable>: Predicate {
    public let key: PartialKeyPath<Model>
    public let descending: Bool
    
    public init(by key: KeyPath<Model, Value>, descending: Bool = true) {
        self.key = key
        self.descending = descending
    }

    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        try mapper.map(self, in: &context)
    }
}
