import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQAR0E_EHPDIe6JmVwZoQBIjDwBlqoRvlQ2PwXsoluURllC45CXqLZzr4L8i8-1w1uLK8mIN5AI0OrkOGckxWelweYhQPDEH03m3HsbbR9JuWL0MVgFH4hUWp7uBfxLNCdjWGTcsRhHOeGGJ807UiqB4LA_CCjQ23HirrD3RZNWftWJQKQCmKI49W8sZBZgo30C8KV7XWvLr4hYVGXLRVHQHvw"
    }
    
    // TODO: - Test Authorization
    
    func testAuthScopes() {
        // Test that auth scopes are correctly converted into a URL-encoded string
        SpotifyAPITests.manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                                           redirectUris: ["music-manager://oauth-callback/"],
                                           scopes: [.playlistReadPrivate, .playlistModifyPrivate])
        XCTAssertEqual(SpotifyAPITests.manager.authClient?.scope, "playlist-read-private%20playlist-modify-private")
    }
    
    func testGetUserId() {
        let manager = SpotifyAPI.manager
        
        var user: UserPublic?
        var error: String?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getUser {
            user = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(user)
            XCTAssertNil(error)
        }
    }
    
    static var allTests = [
        ("testAuthScopes", testAuthScopes),
        ("testGetUserId", testGetUserId),
    ]
}
