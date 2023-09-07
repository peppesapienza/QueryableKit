/// The `Queryable` protocol defines a type that can be queried
/// using predicates conforming to the `QueryPredicate` protocol.
public protocol Queryable: Codable {
    
    /// Returns the string path that corresponds to the provided key path, if one exists.
    ///
    /// - Parameter path: The key path to convert to a string path.
    /// - Returns: The string path that corresponds to the provided key path, or `nil` if the key path cannot be converted to a string path.
    static func field(_ path: PartialKeyPath<Self>) -> String?
}
