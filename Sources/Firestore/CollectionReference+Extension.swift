import QueryableCore
import FirebaseFirestore
import FirebaseFirestoreSwift

public extension CollectionReference {
    func query(_ predicates: [any Predicate]) -> Query {
        guard !predicates.isEmpty else { return self }
        
        let mapper = FirestoreMapper()
        var result: Query = self
        
        do {
            try predicates.forEach { predicate in
                try predicate.map(using: mapper, in: &result)
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        
        return result
    }
}
