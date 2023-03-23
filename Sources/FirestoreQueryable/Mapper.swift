import Queryable
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreMapper: PredicateMapper {
    @discardableResult
    func map<Model, Value>(_ predicate: Where<Model, Value>, in context: inout Query) throws -> QueryPredicate {
        switch predicate.operator {
        case .equalTo:
            context = context.whereField(try predicate.field(), isEqualTo: predicate.value)
            return .where(try predicate.field(), isEqualTo: predicate.value)
            
        case .isGreaterThan:
            context = context.whereField(try predicate.field(), isGreaterThan: predicate.value)
            return .where(try predicate.field(), isGreaterThan: predicate.value)
            
        case .isLessThan:
            context = context.whereField(try predicate.field(), isLessThan: predicate.value)
            return .where(try predicate.field(), isLessThan: predicate.value)
            
        case .isGreaterThanOrEqualTo:
            context = context.whereField(try predicate.field(), isGreaterThanOrEqualTo: predicate.value)
            return .whereField(try predicate.field(), isGreaterThanOrEqualTo: predicate.value)
            
        case .isLessThanOrEqualTo:
            context = context.whereField(try predicate.field(), isLessThanOrEqualTo: predicate.value)
            return .where(try predicate.field(), isLessThanOrEqualTo: predicate.value)
            
        case .isAnyOf:
            context = context.whereField(try predicate.field(), arrayContainsAny: predicate.value as! [Any])
            return .where(try predicate.field(), arrayContainsAny: predicate.value as! [Any])
            
        case .contains:
            context = context.whereField(try predicate.field(), arrayContains: predicate.value)
            return .whereField(try predicate.field(), arrayContains: predicate.value)
        }
    }
    
    func map<Model, Value>(_ predicate: Order<Model, Value>, in context: inout Query) throws -> QueryPredicate {
        context = context.order(by: try predicate.field(), descending: predicate.descending)
        return .order(by: try predicate.field(), descending: predicate.descending)
    }
}
