import SwiftSyntax

extension DeclGroupSyntax {
    
    func casesNameOfEnum<T>(conformingTo enumType: T.Type) -> [TokenSyntax]? {
        memberBlock.members
            .first(where: {
                guard
                    let enumDecl = $0.decl.as(EnumDeclSyntax.self),
                    let types = enumDecl.inheritanceClause?.inheritedTypes
                else { return false }
                
                return types.contains { $0.type.as(IdentifierTypeSyntax.self)?.name.text == "\(enumType.self)" }
            })?
            .decl.as(EnumDeclSyntax.self)?
            .memberBlock.members
            .compactMap {
                $0.decl.as(EnumCaseDeclSyntax.self)?.elements.first?.name.trimmed
            }
    }
}

extension MemberBlockSyntax {
    var variables: [VariableDeclSyntax] {
        members
            .compactMap {
                $0.decl.as(VariableDeclSyntax.self)
            }
    }
}
