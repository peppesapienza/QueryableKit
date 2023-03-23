import XCTest
import Queryable
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseCore
@testable import FirestoreQueryable

struct Person: Queryable {
    let id: String
    let name: String
    let cityId: String
    let friendIds: [String]
    
    static func field(_ path: PartialKeyPath<Person>) -> String? {
        switch path {
        case \.name: return CodingKeys.name.stringValue
        case \.cityId: return CodingKeys.cityId.stringValue
        case \.friendIds: return CodingKeys.friendIds.stringValue
        default: return nil
        }
    }
}

struct FirebaseLoader {
    static private(set) var configured: Bool = false
    
    static func configure() throws {
        guard !configured else { return }
        configured = true
        
        let secrets = try Secrets.load()
        
        let appOptions = FirebaseOptions(
            googleAppID: secrets.googleAppID,
            gcmSenderID: secrets.gcmSenderID
        )
        appOptions.apiKey = secrets.apiKey
        appOptions.projectID = secrets.projectID
        
        FirebaseApp.configure(options: appOptions)
    }
}

final class FirestoreIntegrationTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        try FirebaseLoader.configure()
    }
    
    func test_givenPersonExist_whenQueryByCityAndName_itMustReturnExpectedResult() async throws {
        let expectedName = "Peppe"
        let expectedCityId = "melbourne"
        
        let snap = try await Firestore.firestore().collection("people").query([
            Where(\Person.cityId, equalTo: expectedCityId),
            Where(\Person.name, equalTo: expectedName)
        ])
        .getDocuments()
        
        XCTAssertEqual(snap.documents.count, 1)
        let doc = try XCTUnwrap(snap.documents.first)
        let person = try doc.data(as: Person.self)
        
        XCTAssertEqual(person.name, expectedName)
        XCTAssertEqual(person.cityId, expectedCityId)
        XCTAssertEqual(person.id, "giuseppe")
    }
    
    func test_givenFriendIds_whenQueryByAnyOf_mustReturnExpectedResult() async throws {
        let anyOfExpectedFriends = ["giuseppe", "emily"]
        
        let snap = try await Firestore.firestore().collection("people").query([
            Contains(anyOf: anyOfExpectedFriends, in: \Person.friendIds)
        ])
        .getDocuments()
        
        let persons = try snap.documents.map { try $0.data(as: Person.self) }
        
        Set(persons.flatMap { $0.friendIds }).forEach { friend in
            XCTAssertTrue(anyOfExpectedFriends.contains(friend))
        }
        
    }
    
    
}
