/// A `Sort`  defines a predicate for sorting condition on `Queryable` object keyPath.
///
/// It also provides a way to define `ascending` or `descending` order.
public struct Sort<Root: Queryable, Value: Comparable>: QueryPredicate {
    public let keyPath: KeyPath<Root, Value>
    public let descending: Bool
    
    public var key: PartialKeyPath<Root> { keyPath }
    
    /// Initializes a new instance of `Sort` with the given keyPath and sort direction.
    ///
    /// - Parameters:
    ///   - key: The keyPath to sort by.
    ///   - descending: A Boolean value indicating whether to sort in descending order. The default value is `true`.
    public init(by key: KeyPath<Root, Value>, descending: Bool = true) {
        self.keyPath = key
        self.descending = descending
    }

    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}
