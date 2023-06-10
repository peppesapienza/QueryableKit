import QueryableCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestorePredicateComposer: PredicateVisitor {
    
    func visit<Path, PathType, Value>(_ predicate: Field<Path, PathType, Value>, in context: inout Query) throws {
        var value: Any = predicate.value
        
        if let raw = predicate.value as? any RawRepresentable {
            value = raw.rawValue
        }
        
        switch predicate.operator {
        case .isEqualTo:
            context = context.whereField(try predicate.field(), isEqualTo: value)
            
        case .isGreaterThan:
            context = context.whereField(try predicate.field(), isGreaterThan: value)
            
        case .isLessThan:
            context = context.whereField(try predicate.field(), isLessThan: value)
            
        case .isGreaterThanOrEqualTo:
            context = context.whereField(try predicate.field(), isGreaterThanOrEqualTo: value)
            
        case .isLessThanOrEqualTo:
            context = context.whereField(try predicate.field(), isLessThanOrEqualTo: value)
            
        case .contains:
            context = context.whereField(try predicate.field(), arrayContains: value)
            
        case .isAnyOf:
            context = context.whereField(try predicate.field(), arrayContainsAny: predicate.value as! [Any])
        }
    }
    
    func visit<Path, PathType>(_ predicate: Sort<Path, PathType>, in context: inout Query) throws {
        context = context.order(by: try predicate.field(), descending: predicate.descending)
    }
    
    func visit(_ predicate: Limit, in context: inout Query) throws {
        context = context.limit(to: predicate.max)
    }
  
}
