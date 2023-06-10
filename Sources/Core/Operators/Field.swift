/// A `Field`  defines a predicate that can be used to compare a `Queryable` key path
/// to a `Value` with a specified `Operator`.
public struct Field<Path: Queryable, PathType, Value> {
    
    public enum Operator: String {
        case isEqualTo
        case isGreaterThan
        case isGreaterThanOrEqualTo
        case isLessThan
        case isLessThanOrEqualTo
        case contains
        case isAnyOf
    }
    
    public let keyPath: KeyPath<Path, PathType>
    public let `operator`: Operator
    public let value: Value
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        try visitor.visit(self, in: &context)
    }
}

extension Field: ModelPredicate {
    public typealias Model = Path
    
    public var key: PartialKeyPath<Path> {
        keyPath
    }
}

public extension Field where PathType: Equatable, Value == PathType {
    init(_ key: KeyPath<Path, PathType>, isEqualTo value: Value) {
        self.init(keyPath: key, operator: .isEqualTo, value: value)
    }
}

public extension Field where PathType: Collection, Value == PathType.Element {
    init(_ key: KeyPath<Path, PathType>, contains value: Value) {
        self.init(keyPath: key, operator: .contains, value: value)
    }
}

public extension Field where PathType: Collection, Value == PathType {
    init(_ key: KeyPath<Path, PathType>, isAnyOf value: Value) {
        self.init(keyPath: key, operator: .isAnyOf, value: value)
    }
}

public extension Field where PathType: Comparable, Value == PathType {
    init(_ key: KeyPath<Path, PathType>, isGreaterThan value: Value) {
        self.init(keyPath: key, operator: .isGreaterThan, value: value)
    }
    
    init(_ key: KeyPath<Path, PathType>, isLessThan value: Value) {
        self.init(keyPath: key, operator: .isLessThan, value: value)
    }
    
    init(_ key: KeyPath<Path, PathType>, isGreaterThanOrEqualTo value: Value) {
        self.init(keyPath: key, operator: .isGreaterThanOrEqualTo, value: value)
    }
    
    init(_ key: KeyPath<Path, PathType>, isLessThanOrEqualTo value: Value) {
        self.init(keyPath: key, operator: .isLessThanOrEqualTo, value: value)
    }
}
