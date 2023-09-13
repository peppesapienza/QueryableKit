public struct Limit: QueryablePredicate {
    public typealias Model = Never
    
    public init(max: Int) {
        self.max = max
    }
    
    public let key: PartialKeyPath<Never> = { \.id }()
    public let max: Int
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}

extension Never: Queryable {
    public static func field(_ path: PartialKeyPath<Never>) -> String? { nil }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func encode(to encoder: Encoder) throws {}
}
