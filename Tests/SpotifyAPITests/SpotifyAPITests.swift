import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQCta6KcG15_Xx8p2gASQdS35IiT1FNejWH-SSBiiTKsxtHtqW9k3OH9JsJ1q7DXHlRoyF8qu6glS0nJq38FBq7TlA9GEdjvPNw6-rsoFwDFK-n1xjRkS60CzVA6NQIzSc3QuFGeFmSsncVQihNZ766FjQxjwXVnEopvQnrFGCAfYOW3Gz9BHpcoIc6L4TQ0AenOXpQcYx_QdfMvTvsH3pyP2w"
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
    
    func testGetUsersPlaylists() {
        let manager = SpotifyAPI.manager
        
        var playlists = [PlaylistSimplified]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getUserPlaylists(id: "f9nj63bwb7v9z4ti8q39ljf4g") {
            playlists = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(playlists)
            XCTAssertNil(error)
            print(playlists.count)
        }
    }
    
    func testGetTrack() {
        let manager = SpotifyAPI.manager
        
        var track: Track?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getTrack(id: "2T4SAwloHxRAtpD2hgykdA") {
            track = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(track)
            XCTAssertNil(error)
        }
    }
    
    func testGetAlbum() {
        let manager = SpotifyAPI.manager
        
        var album: Album?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getAlbum(id: "386IqvSuljaZsMjwDGGdLj") {
            album = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(album)
            XCTAssertNil(error)
        }
    }
    
    func testGetArtist() {
        let manager = SpotifyAPI.manager
        
        var artist: Artist?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getArtist(id: "25uiPmTg16RbhZWAqwLBy5") {
            artist = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(artist)
            XCTAssertNil(error)
        }
    }
    
    
    static var allTests = [
        ("testAuthScopes", testAuthScopes),
        ("testGetUserId", testGetUserId),
    ]
}
