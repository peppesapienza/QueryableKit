/// The `Predicate` protocol defines a type that represents a filter condition
/// that can be used to query a `Model` conforming to the `Queryable` protocol.
public protocol Predicate<Model> where Model: Queryable {
    
    associatedtype Model
    
    /// A `PartialKeyPath` that identifies the property of the `Model` that the predicate applies to.
    var key: PartialKeyPath<Model> { get }
    
    /// Applies a mapper to the `Predicate` and updates the provided context.
    ///
    /// - Parameters:
    ///   - mapper: The `PredicateMapper` to apply to the `Predicate`.
    ///   - context: The context to update with the results of the mapper.
    ///
    /// - Returns: The result of applying the mapper to the `Predicate`.
    ///
    /// - Throws: Any error thrown by the mapper.
    @discardableResult
    func map<Mapper: PredicateMapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes
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
    
    @discardableResult
    public func map<Mapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes where Mapper: PredicateMapper {
        throw NotImplemented(in: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func map<Mapper: PredicateMapper>(using mapper: Mapper, in context: inout Mapper.Context) throws -> Mapper.MapRes
        """)
    }
}
