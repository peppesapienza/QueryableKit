public protocol PredicateVisitor {
    associatedtype Context
    
    func visit<Model, Value>(_ predicate: IsEqual<Model, Value>, in context: inout Context) throws
    func visit<Model, Value>(_ predicate: Compare<Model, Value>, in context: inout Context) throws
    func visit<Model, Value>(_ predicate: Contains<Model, Value>, in context: inout Context) throws
    func visit<Model, Value>(_ predicate: Order<Model, Value>, in context: inout Context) throws
}

