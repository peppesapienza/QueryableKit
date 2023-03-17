import Queryable
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreMapper: PredicateMapper {
    func map<Model, Value>(_ predicate: Where<Model, Value>) throws -> QueryPredicate {
        switch predicate.operator {
        case .equalTo: return .where(try predicate.field(), isEqualTo: predicate.value)
        case .isGreaterThan: return .where(try predicate.field(), isGreaterThan: predicate.value)
        case .isLessThan: return .where(try predicate.field(), isLessThan: predicate.value)
        case .isGreaterThanOrEqualTo: return .whereField(try predicate.field(), isGreaterThanOrEqualTo: predicate.value)
        case .isLessThanOrEqualTo: return .where(try predicate.field(), isLessThanOrEqualTo: predicate.value)
        }
    }
    
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Query) throws {
        switch predicate.operator {
        case .equalTo:
            context = context.whereField(try predicate.field(), isEqualTo: predicate.value)
            
        case .isGreaterThan:
            context = context.whereField(try predicate.field(), isGreaterThan: predicate.value)
            
        case .isLessThan:
            context = context.whereField(try predicate.field(), isLessThan: predicate.value)
            
        case .isGreaterThanOrEqualTo:
            context = context.whereField(try predicate.field(), isGreaterThanOrEqualTo: predicate.value)
            
        case .isLessThanOrEqualTo:
            context = context.whereField(try predicate.field(), isLessThanOrEqualTo: predicate.value)
        }
    }
}
