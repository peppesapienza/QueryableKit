import QueryableCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestorePredicateComposer: PredicateVisitor {
    
    func visit<Path, PathType, Value>(_ predicate: Field<Path, PathType, Value>, in context: inout Query) throws {
        switch predicate.operator {
        case .isEqualTo:
            context = context.whereField(try predicate.field(), isEqualTo: predicate.value)
            
        case .isGreaterThan:
            context = context.whereField(try predicate.field(), isGreaterThan: predicate.value)
            
        case .isLessThan:
            context = context.whereField(try predicate.field(), isLessThan: predicate.value)
            
        case .isGreaterThanOrEqualTo:
            context = context.whereField(try predicate.field(), isGreaterThanOrEqualTo: predicate.value)
            
        case .isLessThanOrEqualTo:
            context = context.whereField(try predicate.field(), isLessThanOrEqualTo: predicate.value)
            
        case .contains:
            context = context.whereField(try predicate.field(), arrayContains: predicate.value)
            
        case .isAnyOf:
            context = context.whereField(try predicate.field(), arrayContainsAny: predicate.value as! [Any])
        }
    }
    
    func visit<Model, Value>(_ predicate: Order<Model, Value>, in context: inout Query) throws {
        context = context.order(by: try predicate.field(), descending: predicate.descending)
    }
  
}
