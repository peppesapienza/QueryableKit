public struct AnyOf<Model: Queryable, Value: Codable>: QueryPredicate {
    public let key: PartialKeyPath<Model>
    public let value: [Value]
    
    public init(_ value: [Value], in key: KeyPath<Model, Value>) {
        self.key = key
        self.value = value
    }
}
