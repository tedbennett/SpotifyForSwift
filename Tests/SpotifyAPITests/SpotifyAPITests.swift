import XCTest
import Alamofire
@testable import SpotifyAPI

final class SpotifyAPITests: XCTestCase {
    static var manager = SpotifyAPI.manager
    
    override class func setUp() {
        manager.initialize(clientId: "e164f018712e4c6ba906a595591ff010",
                           redirectUris: ["music-manager://oauth-callback/"],
                           scopes: [])
        manager.authClient?.accessToken = "BQD2gl3qbOlzTCHRY8xL9K0A-R8dG1BSyoaiZuj_uXsqsvBEyDExot1CqCCcEd3gsvRlVPF_AJr9LN9FgoFwWrmuwWDHLrEXF6spswizpV2LLyTekrpBVnxBhgya1bcvP6IbDCe2eF0ub7qqn-vGUtFaAw8xYrdsDmNYvJp8dXNK"
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
    
    func testGetOwnPlaylists() {
        let manager = SpotifyAPI.manager
        
        var playlists = [PlaylistSimplified]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getOwnPlaylists {
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
    
    func testGetUsersPlaylists() {
        let manager = SpotifyAPI.manager
        
        var playlists = [PlaylistSimplified]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getUsersPlaylists(id: "f9nj63bwb7v9z4ti8q39ljf4g") {
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
            playlists.forEach {pl in print("\(pl.id), \(pl.name)")}
        }
    }
    
    func testGetPlaylistsTracks() {
        let manager = SpotifyAPI.manager
        
        var tracks = [PlaylistTrackWrapper]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getPlaylistsTracks(id: "08tzmWUNows4krYs1wpGLm", country: "GB") {
            tracks = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(tracks)
            XCTAssertNil(error)
            print(tracks)
        }
    }
    
    func testGetPlaylistImages() {
        let manager = SpotifyAPI.manager
        
        var images: [Image]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getPlaylistImages(id: "08tzmWUNows4krYs1wpGLm") {
            images = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            XCTAssertNotNil(images)
            XCTAssertNil(error)
            //print(images?.map {img in img.height})
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
    
    func testGetTracks() {
        let manager = SpotifyAPI.manager
        
        var tracks: [Track?]?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getTracks(ids: ["113sWqjcYyjbb4caE8wVsV","1tnAZoY7RXaGwMdQFcxfdC","3IIFPtZ5HZ1SWvtloTY0za","0TOUhXumBiPoCHYJXnobjx"]) {
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
            //tracks?.forEach {track in print(track?.name, track?.id)}
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
        
        manager.getAlbumsTracks(id: "4UWPrrDdzEsdMUDzYM8FC6") {
            tracks = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            tracks.forEach {track in print(track.name, track.id)}
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
    
    // requires user-library-read
    func testGetLibraryAlbums() {
        let manager = SpotifyAPI.manager
        
        var albums = [SavedAlbum]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getLibraryAlbums {
            albums = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            albums.forEach {album in
                print(album.album.name)
            }
            XCTAssertNotEqual(albums.count, 0)
            XCTAssertNil(error)
        }
    }
    
    // requires user-library-read
    func testGetLibraryTracks() {
        let manager = SpotifyAPI.manager
        
        var tracks = [SavedTrack]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getLibraryTracks {
            tracks = $0
            error = $1
            exp.fulfill()
        }
        waitForExpectations(timeout: 100) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            print(tracks.count)
            XCTAssertNotEqual(tracks.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testSearch() {
        let manager = SpotifyAPI.manager
        
        var tracks = [Track]()
        var next: URL?
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.search(for: "Taylor Swift") { (results: [Track], url: URL?, searchError: Error?) in
            tracks = results
            next = url
            error = searchError
            exp.fulfill()
        }
        waitForExpectations(timeout: 100) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            tracks.forEach {track in print(track.name)}
            //print(next)
            XCTAssertNotEqual(tracks.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testGetTracksFromIsrc() {
        let manager = SpotifyAPI.manager
        var tracks = [Track]()
        var error: Error?
        
        let exp = expectation(description: "Check request is successful")
        
        manager.getPlaylistsTracks(id: "7rKuU4sYp5WDiu5r2prnML", country: "GB") { playlistTracks, _ in
            var i = 1
            
            let oldTracks = playlistTracks.filter {$0.track.externalIds?.isrc != nil}.map {$0.track}
            let total = oldTracks.count
            print(total)
            oldTracks.forEach {track in
                if let isrc = track.externalIds?.isrc {
                    manager.getTrackFromIsrc(isrc) { (results, _, searchError) in
                        tracks.append(contentsOf: results)
                        error = searchError
                        i += 1
                        if i == total {
                            exp.fulfill()
                        }
                    }
                }
            }
        }
        waitForExpectations(timeout: 100) {expError in
            if let expError = expError {
                XCTFail("waitForExpectationsWithTimeout errored: \(expError)")
            }
            print(tracks.count)
            XCTAssertNotEqual(tracks.count, 0)
            XCTAssertNil(error)
        }
    }
    
    func testGetJsonDataFrom() {
        let manager = SpotifyAPI.manager
        
        let data = manager.requestBody(from: ["name": "New Playlist", "description": nil, "public": true, "collaborative": nil])
        
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
        print(json)
        XCTAssertEqual(json["name"] as? String, "New Playlist")
        XCTAssertNil(json["description"])
        XCTAssertEqual(json["public"] as? Bool, true)
        XCTAssertNil(json["collaborative"])
    }
}
