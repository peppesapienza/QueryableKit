public struct Order<Model: Queryable, Value: Comparable>: Predicate {
    public let key: PartialKeyPath<Model>
    public let descending: Bool
    
    public init(by key: KeyPath<Model, Value>, descending: Bool = true) {
        self.key = key
        self.descending = descending
    }

    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}
