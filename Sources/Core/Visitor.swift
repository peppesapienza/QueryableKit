public protocol PredicateVisitor {
    associatedtype Context
    
    func visit<Path, PathType, Value>(_ predicate: Field<Path, PathType, Value>, in context: inout Context) throws
    func visit<Path, PathType>(_ predicate: Sort<Path, PathType>, in context: inout Context) throws
    func visit(_ predicate: Limit, in context: inout Context) throws
}

