import QueryableCore
import FirebaseFirestore
import FirebaseFirestoreSwift

public extension CollectionReference {
    func query(_ predicates: [any QueryPredicate]) -> Query {
        guard !predicates.isEmpty else { return self }
        
        let composer = FirestorePredicateComposer()
        var result: Query = self
        
        do {
            try predicates.forEach { predicate in
                try predicate.visit(using: composer, in: &result)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        
        return result
    }
}
