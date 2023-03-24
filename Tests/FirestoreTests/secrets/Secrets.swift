import Foundation

struct Secrets: Decodable {
    let googleAppID: String
    let gcmSenderID: String
    let apiKey: String
    let projectID: String
    
    static func load() throws -> Self {
        let secretsFileUrl = Bundle.module.url(forResource: "secrets", withExtension: "json")
        
        guard let secretsFileUrl = secretsFileUrl, let secretsFileData = try? Data(contentsOf: secretsFileUrl) else {
            fatalError("No `secrets.json` file found.")
        }
        
        return try JSONDecoder().decode(Self.self, from: secretsFileData)
    }
}
