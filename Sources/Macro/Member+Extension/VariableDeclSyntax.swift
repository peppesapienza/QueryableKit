import SwiftSyntax

extension VariableDeclSyntax {
    var isGetter: Bool {
        let accessors = bindings.compactMap { $0.accessorBlock }
        
        if let first = accessors.first?.accessors,
           let accessorDeclList = first.as(AccessorDeclListSyntax.self),
           accessorDeclList.count == 1,
           let first = accessorDeclList.first,
           first.accessorSpecifier.tokenKind == .keyword(.get)
        {
            return true
        }
        
        // Should be true when a property is a get-only defined withouth accessor decl.
        // var foo: Int { 123 }
        if let first = accessors.first?.accessors,
           first.as(CodeBlockItemListSyntax.self) != nil
        {
            return true
        }
        
        return false
    }
    
    /// The variable names
    var identifiers: [TokenSyntax] {
        bindings.compactMap {
            $0.pattern.as(IdentifierPatternSyntax.self)?.identifier
        }
    }
}
