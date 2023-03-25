/// `Contains` is a `Predicate`  and represents a filter condition
/// that checks if a given array property of a `Model` contains a specific value or any of a set of values.
public struct Contains<Model: Queryable, Value>: Predicate {
    
    public enum Operator: String {
        case anyOf
        case contains
    }
    
    public var key: PartialKeyPath<Model> { keyPath }
    
    public let value: [Value]
    public let `operator`: Operator
    public let keyPath: KeyPath<Model, [Value]>
    
    public init(_ value: Value, in key: KeyPath<Model, [Value]>) {
        self.keyPath = key
        self.value = [value]
        self.operator = .contains
    }
    
    public init(anyOf value: [Value], in key: KeyPath<Model, [Value]>) {
        self.keyPath = key
        self.value = value
        self.operator = .anyOf
    }
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}
