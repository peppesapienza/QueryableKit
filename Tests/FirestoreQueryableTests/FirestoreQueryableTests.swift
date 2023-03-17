import XCTest
import Queryable
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseCore
@testable import FirestoreQueryable

struct Person: Queryable {
    let name: String
    let cityId: String
    
    static func field(_ path: PartialKeyPath<Person>) -> String? {
        switch path {
        case \.name: return CodingKeys.name.stringValue
        case \.cityId: return CodingKeys.cityId.stringValue
        default: return nil
        }
    }
}

final class FirestoreIntegrationTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        
        let secrets = try Secrets.load()
        
        let appOptions = FirebaseOptions(
            googleAppID: secrets.googleAppID,
            gcmSenderID: secrets.gcmSenderID
        )
        appOptions.apiKey = secrets.apiKey
        appOptions.projectID = secrets.projectID
        
        FirebaseApp.configure(options: appOptions)
    }
    
    func test_givenPersonExist_whenQueryByCityAndName_itMustReturnExpectedResult() async throws {
        
        let expectedName = "Giuseppe"
        let expectedCityId = "tSF3KCNbKuwja68Y4nr1"
        
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
    }
    
    
}
