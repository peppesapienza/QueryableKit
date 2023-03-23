/**
 A `Where` is  a `Predicate` that represents a condition to be met by a certain key-value pair of a `Queryable` model.
 
 - Parameters:
 - Model: The queryable model.
 - Value: The type of the property being compared.
 
 Example:
 creates a predicate where the `city` property of the `Person` model must be equal to "Melbourne".
 ```
 Where(\Person.city, equalTo: "Melbourne")
 ```
 */
public struct Where<Model: Queryable, Value: Equatable & Comparable>: Predicate {
    public enum Operator: String {
        case equalTo
        case isGreaterThan
        case isGreaterThanOrEqualTo
        case isLessThan
        case isLessThanOrEqualTo
    }
    
    public var key: PartialKeyPath<Model> { keyPath }
    public let value: Value
    public let `operator`: Operator
    
    public let keyPath: KeyPath<Model, Value>
    
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
    
    public init(_ key: KeyPath<Model, Value>, _ op: Operator, _ value: Value) {
        self.operator = op
        self.value = value
        self.keyPath = key
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        try mapper.map(self, in: &context)
    }
}

public func ==<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, equalTo: rhs)
}

public func <<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isLessThan: rhs)
}

public func <=<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isLessThanOrEqualTo: rhs)
}

public func ><Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isGreaterThan: rhs)
}

public func >=<Model: Queryable, Value: Equatable & Comparable>(lhs: KeyPath<Model, Value>, rhs: Value) -> some Predicate {
    Where(lhs, isGreaterThanOrEqualTo: rhs)
}


