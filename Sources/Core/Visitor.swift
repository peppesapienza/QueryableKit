public protocol PredicateVisitor {
    associatedtype Context
    
    func visit<Root, RootValue, Value>(_ predicate: Field<Root, RootValue, Value>, in context: inout Context) throws
    func visit<Root, RootValue>(_ predicate: Sort<Root, RootValue>, in context: inout Context) throws
    func visit(_ predicate: Limit, in context: inout Context) throws
}

