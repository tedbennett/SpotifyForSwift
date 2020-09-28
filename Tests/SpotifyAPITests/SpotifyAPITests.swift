import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQCJzN8M6Mx2P0kuAfzVLZvcZa1NsdFJtibQSv_jCHPV_NejsPSQF2gam6yULGdRMH50kwx7Jz9IIVIjhrdSXSnoLLzBihwof76VR-iksEf9EOprEX5UJMj32NVLvag7qJdryaa41BZ6yCM2mZZjmdZeUwQLQ_2bGGuh4rgy5BnEiDeVYz1-oogndsiy5T46n41nzs1Y73S_etdw7L_U-5jVYw"
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
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getOwnUserProfile {
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
            XCTAssertEqual(user?.displayName, "Ted")
        }
    }
    
    func testGetUserIdWithResponseError() {
        let manager = SpotifyAPI.manager
        
        var user: UserPublic?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.authClient?.accessToken = "BQAR0E_EHPDIe6JmVwZoQBIjDwBlqoRvlQ2PwXsoluURllC45CXqLZzr4L8i8-1w1uLK8mIN5AI0OrkOGckxWelweYhQPDEH03m3HsbbR9JuWL0MVgFH4hUWp7uBfxLNCdjWGTcsRhHOeGGJ807UiqB4LA_CCjQ23HirrD3RZNWftWJQKQCmKI49W8sZBZgo30C8KV7XWvLr4hYVGXLRVHQHvw"
        
        manager.getOwnUserProfile {
            user = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNil(user)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetPlaylist() {
        let manager = SpotifyAPI.manager
        
        var playlist: Playlist?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getPlaylist(id: "7rKuU4sYp5WDiu5r2prnML") {
            playlist = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(playlist)
            XCTAssertNil(error)
        }
    }
    
    
    static var allTests = [
        ("testAuthScopes", testAuthScopes),
        ("testGetUserId", testGetUserId),
    ]
}
