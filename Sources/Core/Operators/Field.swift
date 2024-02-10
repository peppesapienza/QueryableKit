/// A `Field`  defines a predicate that can be used to compare a `QueryableModel` key path
/// to a `Value` with a specified `Operator`.
public struct Field<Root: QueryableModel, RootValue, Value> {
    
    public enum Operator: String {
        case isEqualTo
        case isGreaterThan
        case isGreaterThanOrEqualTo
        case isLessThan
        case isLessThanOrEqualTo
        case contains
        case isAnyOf
    }
    
    public let keyPath: KeyPath<Root, RootValue>
    public let `operator`: Operator
    public let value: Value
    
    public func visit<Visitor>(
        using visitor: Visitor,
        in context: inout Visitor.Context
    ) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}

extension Field: QueryablePredicate {
    public typealias Model = Root
    
    public var key: PartialKeyPath<Root> {
        keyPath
    }
}

public extension Field where RootValue: Equatable, Value == RootValue {
    init(_ key: KeyPath<Root, RootValue>, isEqualTo value: Value) {
        self.init(keyPath: key, operator: .isEqualTo, value: value)
    }
}

public extension Field where RootValue: Collection, Value == RootValue.Element {
    init(_ key: KeyPath<Root, RootValue>, contains value: Value) {
        self.init(keyPath: key, operator: .contains, value: value)
    }
}

public extension Field where RootValue: Collection, Value == RootValue {
    init(_ key: KeyPath<Root, RootValue>, isAnyOf value: Value) {
        self.init(keyPath: key, operator: .isAnyOf, value: value)
    }
}

public extension Field where RootValue: Comparable, Value == RootValue {
    init(_ key: KeyPath<Root, RootValue>, isGreaterThan value: Value) {
        self.init(keyPath: key, operator: .isGreaterThan, value: value)
    }
    
    init(_ key: KeyPath<Root, RootValue>, isLessThan value: Value) {
        self.init(keyPath: key, operator: .isLessThan, value: value)
    }
    
    init(_ key: KeyPath<Root, RootValue>, isGreaterThanOrEqualTo value: Value) {
        self.init(keyPath: key, operator: .isGreaterThanOrEqualTo, value: value)
    }
    
    init(_ key: KeyPath<Root, RootValue>, isLessThanOrEqualTo value: Value) {
        self.init(keyPath: key, operator: .isLessThanOrEqualTo, value: value)
    }
}
