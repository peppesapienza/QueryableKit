/// The `Queryable` macro defines a type that can be queried
/// using predicates conforming to the `QueryablePredicate` protocol.
@attached(member, names: named(field))
@attached(extension, conformances: QueryableModel)
public macro Queryable() = #externalMacro(module: "QueryableMacros", type: "QueryableMacro")
