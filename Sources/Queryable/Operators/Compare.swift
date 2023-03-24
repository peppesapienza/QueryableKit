public struct Compare<Model: Queryable, Value: Comparable>: Predicate {
    public enum Operator: String {
        case isGreaterThan
        case isGreaterThanOrEqualTo
        case isLessThan
        case isLessThanOrEqualTo
    }
    
    public var key: PartialKeyPath<Model> { keyPath }
    public let value: Value
    public let `operator`: Operator
    
    public let keyPath: KeyPath<Model, Value>
    
    public init(_ key: KeyPath<Model, Value>, isGreaterThan value: Value) {
        self.init(key, .isGreaterThan, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, isLessThan value: Value) {
        self.init(key, .isLessThan, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, isGreaterThanOrEqualTo value: Value) {
        self.init(key, .isGreaterThanOrEqualTo, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, isLessThanOrEqualTo value: Value) {
        self.init(key, .isLessThanOrEqualTo, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, _ op: Operator, _ value: Value) {
        self.operator = op
        self.value = value
        self.keyPath = key
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        try mapper.map(self, in: &context)
    }
    
    func isSatisfied(by candidate: Value) -> Bool  {
        switch `operator` {
        case .isLessThanOrEqualTo: return candidate <= value
        case .isLessThan: return candidate < value
        case .isGreaterThan: return candidate > value
        case .isGreaterThanOrEqualTo: return candidate >= value
        }
    }
}

public func <<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Compare(lhs, isLessThan: rhs)
}

public func <=<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Compare(lhs, isLessThanOrEqualTo: rhs)
}

public func ><Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Compare(lhs, isGreaterThan: rhs)
}

public func >=<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Compare(lhs, isGreaterThanOrEqualTo: rhs)
}


