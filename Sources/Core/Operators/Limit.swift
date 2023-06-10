public struct Limit: Predicate {
    
    public init(max: Int) {
        self.max = max
    }
    
    public let max: Int
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}
