public struct Sort<Path: Queryable, Value: Comparable>: Predicate {
    public let keyPath: KeyPath<Path, Value>
    public let descending: Bool
    
    public var key: PartialKeyPath<Path> { keyPath }
    
    public init(by key: KeyPath<Path, Value>, descending: Bool = true) {
        self.keyPath = key
        self.descending = descending
    }

    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}
