import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQAJylOavwNo9yU8BqtRpLgXB8OijoI_18AvxbalIG0vECFQLshQ-4_jAqZ1GJ0ouPe-Rhno1JU8lvd8XiVLq3_7NjqrOH8gEhG-1g2c-by_k-0NKhB-uTq99vmzZ2Lc-vHvKu3KZg8-qL1E1jHJxllJQMdwu4dOat78-fc5xW4G9FEtjr0DRnIIe-r-51FYbN1JF6u2KMQp3sWp8eq-hCwapg"
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
    
    
    static var allTests = [
        ("testAuthScopes", testAuthScopes),
        ("testGetUserId", testGetUserId),
    ]
}
