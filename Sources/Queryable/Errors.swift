import Foundation

struct NotImplemented: Error {}

public struct FieldMissing<Model: Queryable>: Error {
    let key: PartialKeyPath<Model>
    
    public var localizedDescription: String {
        """
        [QueryableError] Key: \(key) doesn't map a path of your model: \(Model.self).
        
        To fix this issue your model must implement the `Queryable.field(_ path: PartialKeyPath<Self>) -> String?` \
        method.
        If you have already implemented it, check that your KeyPath is mapped and returns a proper String.
        """
    }
}
