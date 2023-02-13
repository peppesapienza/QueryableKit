public protocol Queryable: Codable {
    static func field(_ path: PartialKeyPath<Self>) -> String?
}
