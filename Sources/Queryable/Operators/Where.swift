public struct Where<Model: Queryable, Value: Codable>: QueryPredicate {
    public enum Operator {
        case equalTo
        case isGreaterThan
        case isLessThan
    }
    
    public let key: PartialKeyPath<Model>
    public let value: Value
    let `operator`: Operator
    
    public init(_ key: KeyPath<Model, Value>, equalTo value: Value) {
        self.init(key, .equalTo, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, isGreaterThan value: Value) {
        self.init(key, .isGreaterThan, value)
    }
    
    public init(_ key: KeyPath<Model, Value>, isLessThan value: Value) {
        self.init(key, .isLessThan, value)
    }
    
    init(_ key: KeyPath<Model, Value>, _ op: Operator, _ value: Value) {
        self.operator = op
        self.key = key
        self.value = value
    }
    
}

public func ==<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some QueryPredicate {
    Where(lhs, equalTo: rhs)
}

public func <<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some QueryPredicate {
    Where(lhs, isLessThan: rhs)
}

public func ><Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some QueryPredicate {
    Where(lhs, isGreaterThan: rhs)
}


