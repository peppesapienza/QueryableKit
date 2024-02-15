import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin

public struct QueryableMacro: MemberMacro {
    
    static let backslashToken = TokenSyntax.backslashToken()
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var variables = declaration.memberBlock.variables
                
        let codingKeys = declaration
            .casesNameOfEnum(conformingTo: CodingKey.self)?
            .compactMap { $0.text } ?? []
        
        variables.removeAll(where: { variable in
            // If the property is a getter it should immediately be removed.
            if variable.isGetter { return true }
            
            // Then checks the presence of a custom CodingKey implementation
            // and removes all variables that are not defined in there.
            guard !codingKeys.isEmpty else { return false }
            let names = variable.identifiers.map { $0.text }
            return !names.contains(where: { codingKeys.contains($0) })
        })
        
        /// Returns the string path associated to the provided key path, if one exists.
        ///
        /// - Parameter path: The key path to convert to a string path.
        /// - Returns: The string path that corresponds to the provided key path, or `nil` if the key path cannot be converted to a string path.
        
        let new = try FunctionDeclSyntax("public static func field(_ path: PartialKeyPath<Self>) -> String?") {
            if variables.isEmpty {
                """
                return nil
                """
            } else {
                """
                switch path {
                \(raw: variables.flatMap { $0.identifiers }.map({ token in
                    "case \(backslashToken).\(token): return CodingKeys.\(token).stringValue"
                }).joined(separator: "\n"))
                default: return nil
                }
                """
            }
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
