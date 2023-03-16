import Queryable
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreMapper: PredicateMapper {
    func map<Model, Value>(_ value: Where<Model, Value>) -> QueryPredicate {
        switch value.operator {
        case .equalTo: return .where(value.field()!, isEqualTo: value)
        case .isGreaterThan: return .where(value.field()!, isGreaterThan: value)
        case .isLessThan: return .where(value.field()!, isLessThan: value)
        }
    }
}

