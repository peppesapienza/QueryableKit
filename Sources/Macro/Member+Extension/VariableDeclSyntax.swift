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
        
        if let first = accessors.first?.accessors,
           let codeBlockList = first.as(CodeBlockItemListSyntax.self),
           codeBlockList.count == 1
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
