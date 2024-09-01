public struct Limit: QueryablePredicate {
    public typealias Model = EmptyQueryableModel
    
    public init(max: Int) {
        self.max = max
    }
    
    public let key: PartialKeyPath<Model>? = nil
    public let max: Int
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}

public struct EmptyQueryableModel: QueryableModel {
    public static func field(_ path: PartialKeyPath<EmptyQueryableModel>) -> String? {
        nil
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func encode(to encoder: Encoder) throws {}
}
