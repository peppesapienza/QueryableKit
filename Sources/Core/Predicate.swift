/// A `Predicate` provides a type-safe way to represent a condition that can be used to
/// filter, sort and query your `Queryable` objects.
public protocol Predicate<Model> where Model: Queryable {
    
    associatedtype Model
    
    /// A `PartialKeyPath` that identifies the property of the `Model` that the predicate applies to.
    var key: PartialKeyPath<Model> { get }
    
    func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor
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
    
    public func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor {
        throw NotImplemented(in: Self.self, context: """
        To fix this issue your Predicate must provide an implementation of \
        func visit<Visitor>(using visitor: Visitor, in context: inout Visitor.Context) throws where Visitor: PredicateVisitor
        """)
    }
}
