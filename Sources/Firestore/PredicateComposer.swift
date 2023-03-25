import QueryableCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestorePredicateComposer: PredicateVisitor {
    
    typealias Context = Query
    
    func visit<Model, Value>(_ predicate: IsEqual<Model, Value>, in context: inout Query) throws {
        context = context.whereField(try predicate.field(), isEqualTo: predicate.value)
    }
    
    func visit<Model, Value>(_ predicate: Compare<Model, Value>, in context: inout Query) throws {
        switch predicate.operator {
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
    
    func visit<Model, Value>(_ predicate: Order<Model, Value>, in context: inout Query) throws {
        context = context.order(by: try predicate.field(), descending: predicate.descending)
    }
    
    func visit<Model, Value>(_ predicate: Contains<Model, Value>, in context: inout Query) throws {
        switch predicate.operator {
        case .contains:
            assert(predicate.value.first != nil)
            assert(predicate.value.count == 1)
            
            context = context.whereField(try predicate.field(), arrayContains: predicate.value.first!)
            
        case .anyOf:
            context = context.whereField(try predicate.field(), arrayContainsAny: predicate.value)
        }
    }
  
}
