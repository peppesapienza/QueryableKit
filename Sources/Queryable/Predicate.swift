/// The `Predicate` protocol defines a type that represents a filter condition
/// that can be used to query a `Model` conforming to the `Queryable` protocol.
public protocol Predicate<Model, Value> where Model: Queryable {
    
    associatedtype Model
    associatedtype Value
    
    /// A `PartialKeyPath` that identifies the property of the `Model` that the predicate applies to.
    var key: PartialKeyPath<Model> { get }
    
    /// The value that the property must match in order for the predicate to be evaluated.
    var value: Value { get }
    
    /// Applies a mapper to the `Predicate` and returns the mapped result.
    ///
    /// - Parameter mapper: The `PredicateMapper` to apply to the `Predicate`.
    /// - Returns: The result of applying the mapper to the `Predicate`.
    /// - Throws: Any error thrown by the mapper.
    func map<Mapper: PredicateMapper>(using mapper: Mapper) throws -> Mapper.MapRes
    
    /// Applies a mapper to the `Predicate` and updates the provided context.
    ///
    /// - Parameters:
    ///   - mapper: The `PredicateMapper` to apply to the `Predicate`.
    ///   - context: The context to update with the results of the mapper.
    ///
    /// - Throws: Any error thrown by the mapper.
    func map<Mapper: PredicateMapper>(using mapper: Mapper, in context: inout Mapper.Context) throws
}

extension Predicate {
    var type: Model.Type { Model.self }
    
    /// Returns the string path that corresponds to the key path being queried, if one exists.
    ///
    /// - Returns: The string path that corresponds to the key path being queried, or `nil` if the key path cannot be converted to a string path.
    /// - Throws: A `FieldMissing` error if the key cannot be converted to a string path.
    public func field() throws -> String {
        guard let field = Model.field(key) else {
            throw FieldMissing(key: key)
        }
        
        return field
    }
    
    public func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        throw NotImplemented(in: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func map<Mapper>(using mapper: Mapper) throws -> Mapper.MapRes where Mapper: PredicateMapper
        """)
    }
    
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws where Mapper: PredicateMapper {
        throw NotImplemented(in: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws where Mapper: PredicateMapper
        """)
    }
}
