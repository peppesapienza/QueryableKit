import Queryable
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreMapper: PredicateMapper {
    func map<Model, Value>(_ value: Where<Model, Value>) throws -> QueryPredicate {
        switch value.operator {
        case .equalTo: return .where(try value.field(), isEqualTo: value)
        case .isGreaterThan: return .where(try value.field(), isGreaterThan: value)
        case .isLessThan: return .where(try value.field(), isLessThan: value)
        }
    }
}
