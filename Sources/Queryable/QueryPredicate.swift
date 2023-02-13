public protocol QueryPredicate<Model, Value> where Model: Queryable {
    associatedtype Model
    associatedtype Value
    
    var key: PartialKeyPath<Model> { get }
    var value: Value { get }
}

extension QueryPredicate {
    var type: Model.Type { Model.self }
    
    public func field() -> String? {
        Model.field(key)
    }
}
