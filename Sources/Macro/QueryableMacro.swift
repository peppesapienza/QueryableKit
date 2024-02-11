import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin


public struct QueryableMacro: MemberMacro {
    
    static let backslashToken = TokenSyntax.backslashToken()
        
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structure = declaration.as(StructDeclSyntax.self) else { return [] }
        
        let variables = structure.memberBlock.members.compactMap {
            $0.decl.as(VariableDeclSyntax.self)
        }
        
        let identifiers = variables.flatMap {
            $0.bindings.compactMap { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier }
        }
        
        /// Returns the string path associated to the provided key path, if one exists.
        ///
        /// - Parameter path: The key path to convert to a string path.
        /// - Returns: The string path that corresponds to the provided key path, or `nil` if the key path cannot be converted to a string path.
                
        let new = try FunctionDeclSyntax("static func field(_ path: PartialKeyPath<Self>) -> String?") {
            """
            switch path {
            \(raw: identifiers.map({ token in
                "case \(backslashToken).\(token): return CodingKeys.\(token).stringValue"
            }).joined(separator: "\n"))
            default: return nil
            }
            """
        }
                
        return [
            DeclSyntax(new)
        ]
    }
}

extension QueryableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let equatableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): QueryableModel {}")
        return [equatableExtension]
    }
}


@main
struct QueryablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        QueryableMacro.self,
    ]
}