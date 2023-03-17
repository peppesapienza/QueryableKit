public struct Where<Model: Queryable, Value: Codable>: Predicate {
    public enum Operator: String {
        case equalTo
        case isGreaterThan
        case isGreaterThanOrEqualTo
        case isLessThan
        case isLessThanOrEqualTo
    }
    
    public let key: PartialKeyPath<Model>
    public let value: Value
    public let `operator`: Operator
    
    public init(_ key: KeyPath<Model, Value>, equalTo value: Value) {
        self.init(key, .equalTo, value)
    }
    
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
    
    init(_ key: KeyPath<Model, Value>, _ op: Operator, _ value: Value) {
        self.operator = op
        self.key = key
        self.value = value
    }
    
    public func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        try mapper.map(self)
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws where Mapper: PredicateMapper {
        try mapper.map(self, in: &context)
    }
}

public func ==<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, equalTo: rhs)
}

public func <<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isLessThan: rhs)
}

public func <=<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isLessThanOrEqualTo: rhs)
}

public func ><Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isGreaterThan: rhs)
}

public func >=<Model: Queryable, Value: Codable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isGreaterThanOrEqualTo: rhs)
}


