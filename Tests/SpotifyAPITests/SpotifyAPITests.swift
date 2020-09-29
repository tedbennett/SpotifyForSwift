import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQDU2wYLGxUjWmP1uy7KTz3aW8VDl0bWsvRM8VGriYHRzG0gxynf1SNUVJoNmSHvUT0lu2MeQyZzcajv-oU7c66VBfaqxeMX4gf9-6s5bj4pX0ETUnekOrQO5jKkvqpmLjulV4Pn0SRW0DoHGd-2rEyV4txmGntkZv-gUbHpwE_ebxCEAdIBEhG2dOrYYrR6SgHXSuyB7wX0LPsYCDw8dEjHfg"
    }
    
    // TODO: - Test Authorization
    
    func testAuthScopes() {
        // Test that auth scopes are correctly converted into a URL-encoded string
        SpotifyAPITests.manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                                           redirectUris: ["music-manager://oauth-callback/"],
                                           scopes: [.playlistReadPrivate, .playlistModifyPrivate])
        XCTAssertEqual(SpotifyAPITests.manager.authClient?.scope, "playlist-read-private%20playlist-modify-private")
    }
    
    func testGetUrlRequest() {
        do {
            let request = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], "e164f018712e4c6ba906a595591ff010", Endpoints[.albums]], queries: ["country":"EN"])
            XCTAssertNotNil(request)
            print(request)
        } catch {
            XCTAssertNil(error)
            print(error)
        }
        
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
    
    func testGetAlbums() {
        let manager = SpotifyAPI.manager
        
        var albums: [Album?]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getAlbums(ids: ["0PiWf1iYUUTHDEPnPTFxqs","4UWPrrDdzEsdMUDzYM8FC6","386IqvSuljaZsMjwDGGdLj","3a9qH2VEsSiOZvMrjaS0Nu"]) {
            albums = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotEqual(albums?.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testGetAlbumsTracks() {
        let manager = SpotifyAPI.manager
        
        var tracks = [TrackSimplified]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getAlbumsTracks(id: "0PiWf1iYUUTHDEPnPTFxqs") {
            tracks = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotEqual(tracks.count, 0)
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
    
    func testGetArtists() {
        let manager = SpotifyAPI.manager
        
        var artists: [Artist?]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getArtists(ids: ["25uiPmTg16RbhZWAqwLBy5","3FPflECmvkrze212dLPRSC","4QM5QCHicznALtX885CnZC","1kMPdZQVdUhMDKDWOJM5iK"]) {
            artists = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotEqual(artists?.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testGetArtistsAlbums() {
        let manager = SpotifyAPI.manager
        
        var albums = [AlbumSimplified]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getArtistsAlbums(id: "25uiPmTg16RbhZWAqwLBy5") {
            albums = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotEqual(albums.count, 0)
            XCTAssertNil(error)
            albums.forEach {album in print(album.id) }
        }
    }
    
    func testGetArtistsTopTracks() {
        let manager = SpotifyAPI.manager
        
        var tracks: [Track]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")

        manager.getArtistsTopTracks(id: "25uiPmTg16RbhZWAqwLBy5", country: "GB") {
            tracks = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotEqual(tracks?.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testGetArtistsRelatedArtists() {
        let manager = SpotifyAPI.manager
        
        var artists: [Artist]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getArtistsRelatedArtists(id: "25uiPmTg16RbhZWAqwLBy5") {
            artists = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            artists?.forEach {artist in
                print(artist.id)
            }
            XCTAssertNotEqual(artists?.count, 0)
            XCTAssertNil(error)
        }
    }
}
