# Queryable

QueryableKit allows you to write and perform type-safe Firestore queries. 

```swift
try await firestore().collection("suburbs").query([
  \Suburb.city == "Melbourne",
  \Suburb.population >= 50_000,
  Field(\Suburb.neighbours, isAnyOf: [3083,3000]),
  Sort(by: \Suburb.distanceFromCityCenter),
  Limit(max: 3)
])
```

## Installation

QueryableKit is in active development and can change at any time. 

### Swift Package Manager

Once you have integrated SPM in your project, you can add QueryableKit inside the `dependencies` field of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/peppesapienza/QueryableKit", branch: "main")
]
```
You can then use `QueryableCore` and/or `FirestoreQueryable` as target dependency:

```swift
dependencies: [
  .product(name: "QueryableCore", package: "QueryableKit"),
  .product(name: "FirestoreQueryable", package: "QueryableKit")
]
```

## Allow your models to be safely queried

The `Queryable` macro adds everything needed for your type to be supported by `FirestoreQueryable` and conforms the type to the `QueryableModel` protocol. For example, if your type's properties perfectly match the Firestore schema, your type will look like this:

```swift
import QueryableCore

@Queryable
struct Person {
    let name: String
    let age: Int
    let friends: [Int]
}
```

### Custom CodingKeys

If your type implements a custom `CodingKey`, QueryableKit will use it to map each `KeyPath` to the corresponding value. In the example, using the `\City.population` will query against the `populationCount` field.

```swift
@Queryable
struct City: Equatable {
    let name: String
    let population: Int
    let suburbs: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case population = "populationCount"
        case suburbs
    }
}
```

## Query your objects safely

Once your model conforms to `QueryableModel` either through the macro `Queryable` or through manual conformance, you can query your data using the `CollectionReference` method `func query(_ predicates: [any QueryablePredicate]) -> Query`:

```swift
import FirestoreQueryable

try await Firestore.firestore().collection("grades").query([
  Field(\Grade.termId, isEqualTo: currentTerm.id),
  Field(\Grade.subjectId, isEqualTo: subject.id),
  Sort(by: \Grade.date)
])
```

### Available predicates

You can use one of the following predicates based on your property type:

```swift
Field(\Foo.bar, contains: Value)
Field(\Foo.bar, isAnyOf: [a, b, c])

Field(\Foo.bar, isEqualTo: Value)
Field(\Foo.bar, isGreaterThan: Value)
Field(\Foo.bar, isGreaterThanOrEqualTo: Value)
Field(\Foo.bar, isLessThan: Value)
Field(\Foo.bar, isLessThanOrEqualTo: Value)

Limit(max: Int)
Sort(by: \Foo.bar, descending: Bool)
```

For example, you can't use a `isGreaterThan:` if your property value is not `Comparable` or you can't use an `isAnyOf` or `contains` if your property is not `Collection`. 




