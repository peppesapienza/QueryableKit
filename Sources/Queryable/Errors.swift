import Foundation

public struct NotImplemented: Error, LocalizedError {
    init<T>(funcName: String = #function, missingIn type: T.Type, context: String = "") {
        self.funcName = funcName
        self.type = "\(type)"
        self.context = context
    }
    
    private let funcName: String
    private let type: String
    private let context: String
    
    public var localizedDescription: String {
        """
        [QueryableError] Looks like your type: \(type) has not implemented: \(funcName).
        \(context)
        """
    }
    
    public var errorDescription: String? {
        localizedDescription
    }
}

public struct FieldMissing<Model: Queryable>: Error, LocalizedError {
    let key: PartialKeyPath<Model>
    
    public var localizedDescription: String {
        """
        [QueryableError] Key: \(key) doesn't map a path of your model: \(Model.self).
        
        To fix this issue your model must implement the `Queryable.field(_ path: PartialKeyPath<Self>) -> String?` \
        method.
        If you have already implemented it, check that your KeyPath is mapped and returns a proper String.
        """
    }
    
    public var errorDescription: String? {
        localizedDescription
    }
}
