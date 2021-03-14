import OAuth2
import Foundation

public class SpotifyAPI {
    var authClient: OAuth2CodeGrant?
    
    public static let manager = SpotifyAPI()
    
    private init() {}
    
    private var userId = ""
    
    // MARK: - Auth
    
    public func initialize(clientId: String, redirectUris: [String], scopes: [AuthScope], usePkce: Bool = true, useKeychain: Bool = true) {
        authClient = OAuth2CodeGrant(settings: [
            "client_id": clientId,
            "authorize_uri": authUrl,
            "token_uri": tokenUrl,
            "redirect_uris": redirectUris,
            "use_pkce": usePkce,
            "scope": scopes.map{scope in scope.rawValue}.joined(separator: "%20"),
            "keychain": useKeychain,
        ] as OAuth2JSON)
    }
    
    public func authorize(completion: @escaping (Bool) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        authClient!.authorize(callback: {authParameters, error in
            if authParameters != nil {
                completion(true)
                self.getOwnUserProfile { user, error in
                    guard let user = user else {
                        print(error.debugDescription)
                        return
                    }
                    self.userId = user.id
                }
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")
                if error?.description == "Refresh token revoked" {
                    self.authClient!.forgetTokens()
                }
                completion(false)
            }
        })
    }
    
    public func forgetTokens() {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        authClient!.forgetTokens()
    }
    
    public func handleRedirect(url: URL) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        authClient!.handleRedirectURL(url)
    }
}

// MARK: - Requests

extension SpotifyAPI {
    func request<Object: Codable>(url: URLRequest, completion: @escaping (Object?, Error?) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 429, let retryDelay = response.value(forHTTPHeaderField: "Retry-After") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryDelay)!) {
                        self.request(url: url, completion: completion)
                    }
                    return
                } else if response.statusCode == 401 {
                    self.authorize { success in
                        if success {
                            self.request(url: url, completion: completion)
                        }
                    }
                    return
                }
            }
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data returned", code: 10, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decoded = try decoder.decode(Object.self, from: data)
                completion(decoded, nil)
            } catch let parseError {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print(json)
                }
                completion(nil, parseError)
            }
        }.resume()
    }
    
    func requestWithoutBodyResponse(url: URLRequest, completion: @escaping (Bool, Error?) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                    case 429:
                        if let retryDelay = response.value(forHTTPHeaderField: "Retry-After") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryDelay)!) {
                                self.requestWithoutBodyResponse(url: url, completion: completion)
                            }
                        }
                        return
                    case 401:
                        self.authorize { success in
                            if success {
                                self.requestWithoutBodyResponse(url: url, completion: completion)
                            }
                        }
                        return
                    case 201, 204:
                        completion(true, nil)
                        return
                    case 403:
                        completion(false, ApiError.invalidScope)
                    case 404:
                        completion(false, ApiError.notFound)
                    default:
                        completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }.resume()
    }
    
    func arrayRequest<Object: Codable>(url: URLRequest, key: String, completion: @escaping ([Object]?, Error?) -> Void) {
        
        let wrappedCompletion: ([String:[Object]]?, Error?) -> Void = { response, error in
            let array = response?[key]
            completion(array, error)
        }
        request(url: url, completion: wrappedCompletion)
    }
    
    func paginatedRequest<Object: Codable>(url: URLRequest, objects: [Object] = [], completion: @escaping ([Object], Error?) -> Void) {
        request(url: url) { (paginatedObjects: Paging<Object>?, error) in
            guard let paginatedObjects = paginatedObjects else {
                completion(objects, error)
                return
            }
            guard error == nil else {
                completion(objects, error)
                return
            }
            var newObjects = objects
            newObjects.append(contentsOf: paginatedObjects.items)
            if let next = paginatedObjects.next {
                let nextUrl = self.getAuthenticatedUrl(url: next, method: .get)
                self.paginatedRequest(url: nextUrl, objects: newObjects, completion: completion)
            } else {
                completion(newObjects, error)
            }
        }
    }
    
    func singlePageRequest<Object: Codable>(url: URLRequest, key: String, completion: @escaping ([Object], URL?, Error?) -> Void) {
        let wrappedCompletion: ([String:Paging<Object>]?, Error?) -> Void = { response, error in
            guard let paginatedObjects = response?[key] else {
                completion([], nil, error)
                return
            }
            completion(paginatedObjects.items, paginatedObjects.next, error)
        }
        request(url: url, completion: wrappedCompletion)
        
    }
}

// MARK: - URL Handling

extension SpotifyAPI {
    func getUrlRequest(for paths: [String], method: HTTPMethod = .get, queries: [String:String] = [:]) throws -> URLRequest  {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard var url = components.url else {
            throw ApiError.invalidUrl
        }
        
        paths.forEach { path in
            url.appendPathComponent(path)
        }
        
        return getAuthenticatedUrl(url: url, method: method)
    }
    
    func getAuthenticatedUrl(url: URL, method: HTTPMethod) -> URLRequest {
        guard let client = authClient else {
            fatalError("Spotify manager not initialized, call initialize() before use")
        }
        
        var request = client.request(forURL: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    func requestBody(from json: [String: Any?]) -> Data {
        var body = [String: Any]()
        for (key, value) in json {
            if value != nil {
                if let bool = value as? Bool {
                    body[key] = bool ? "true" : "false"
                } else {
                    body[key] = value
                }
            }
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        return jsonData ?? Data()
    }
}

// MARK: - Users

extension SpotifyAPI {
    
    public func getOwnUserProfile(completion: @escaping (UserPublic?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me]])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
}

// MARK: - Playlists

extension SpotifyAPI {
    
    public func getPlaylist(id: String, completion: @escaping (Playlist?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    // needs playlist-read-private or playlist-read-collaborative for private/collaborative playlists
    public func getOwnPlaylists(completion: @escaping ([PlaylistSimplified], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.playlists]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    // needs playlist-read-private or playlist-read-collaborative for private/collaborative playlists
    public func getUsersPlaylists(id: String? = nil, completion: @escaping ([PlaylistSimplified], Error?) -> Void) {
        do {
            let id = id ?? userId
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.users], id, Endpoints[.playlists]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    public func getPlaylistsTracks(id: String, country: String, completion: @escaping ([PlaylistTrackWrapper], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.tracks]], queries: ["market": country, "limit": "50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    public func getPlaylistImages(id: String, completion: @escaping ([Image]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.images]])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func createPlaylist(userId: String?, name: String, description: String?, isPublic: Bool, collaborative: Bool, completion: @escaping (Playlist?, Error?) -> Void) {
        do {
            let id = userId ?? self.userId
            var url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.users], id, Endpoints[.playlists]], method: .post)
            
            url.httpBody = requestBody(from: ["name": name, "description": description, "public": isPublic, "collaborative": collaborative])
            
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func addTracksToPlaylist(id: String, uris: [String], completion: @escaping (Bool, Error?) -> Void) {
        do {
            var url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.tracks]], method: .post)
            // limited to 100 tracks per request
            
            let chunkedUris = uris.chunked(into: 100)
            
            for chunk in chunkedUris {
                url.httpBody = requestBody(from: ["uris": chunk])
                
                requestWithoutBodyResponse(url: url, completion: completion)
            }
        } catch let error {
            completion(false, error)
        }
    }
    
    public func createPlaylist(userId: String? = nil, name: String, description: String, uris: [String], isPublic: Bool, collaborative: Bool, completion: @escaping (Bool, Error?) -> Void) {
        createPlaylist(userId: userId, name: name, description: description, isPublic: isPublic, collaborative: collaborative) { playlist, error in
            guard let playlist = playlist else {
                print(error.debugDescription)
                return
            }
            self.addTracksToPlaylist(id: playlist.id, uris: uris, completion: completion)
        }
    }
}

// Array Helper function

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


// MARK: - Tracks

extension SpotifyAPI {
    
    public func getTrack(id: String, completion: @escaping (Track?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.tracks], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getTracks(ids: [String], completion: @escaping ([Track?]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.tracks]], queries:  ["ids": ids.joined(separator: ",")])
            arrayRequest(url: url, key: "tracks", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
}

// MARK: - Albums

extension SpotifyAPI {
    
    public func getAlbum(id: String, completion: @escaping (Album?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getAlbums(ids: [String], completion: @escaping ([Album?]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums]], queries:  ["ids": ids.joined(separator: ",")])
            arrayRequest(url: url, key: "albums", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getAlbumsTracks(id: String, completion: @escaping ([TrackSimplified], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums], id, Endpoints[.tracks]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
}

// MARK: - Artists

extension SpotifyAPI {
    
    public func getArtist(id: String, completion: @escaping (Artist?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getArtists(ids: [String], completion: @escaping ([Artist?]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists]], queries:  ["ids": ids.joined(separator: ",")])
            arrayRequest(url: url, key: "artists", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getArtistsAlbums(id: String, completion: @escaping ([AlbumSimplified], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.albums]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    public func getArtistsTopTracks(id: String, country: String, completion: @escaping ([Track]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.topTracks]], queries: ["market": country])
            arrayRequest(url: url, key: "tracks", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    public func getArtistsRelatedArtists(id: String, completion: @escaping ([Artist]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.relatedArtists]])
            arrayRequest(url: url, key: "artists", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
}

// MARK: - Library

extension SpotifyAPI {
    
    // requires user-library-read
    public func getLibraryAlbums(completion: @escaping ([SavedAlbum], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.albums]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    // requires user-library-read
    public func getLibraryTracks(completion: @escaping ([SavedTrack], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.tracks]], queries: ["limit":"50"])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
}

// MARK: - Search

extension SpotifyAPI {
    
    // NOTE: Limited to search for one type of object at a time
    public func search<Object: Codable>(for queries: String, completion: @escaping ([Object], URL?, Error?) -> Void) {
        var type: String
        switch Object.self {
            case is Playlist.Type: type = SearchType[.playlist]
            case is Artist.Type: type = SearchType[.artist]
            case is AlbumSimplified.Type: type = SearchType[.album]
            case is ShowSimplified.Type: type = SearchType[.show]
            case is Track.Type: type = SearchType[.track]
            case is EpisodeSimplified.Type: type = SearchType[.episode]
            default:
                completion([], nil, ApiError.invalidSearchObject)
                return
        }
        guard let queryString = queries.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([], nil, ApiError.invalidSearchObject)
            return
        }
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.search]], queries: ["q": queryString, "type": type])
            singlePageRequest(url: url, key: "\(type)s", completion: completion)
        } catch let error {
            completion([], nil, error)
        }
    }
    
    public func getTrackFromIsrc(_ isrc: String, completion: @escaping ([Track], URL?, Error?) -> Void) {
        let type = SearchType[.track]
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.search]], queries: ["q": "isrc:\(isrc)", "type": type, "limit":"1"])
            singlePageRequest(url: url, key: "\(type)s", completion: completion)
        } catch let error {
            completion([], nil, error)
        }
    }
}

// MARK: - Queue

extension SpotifyAPI {
    public func addTrackToQueue(uri: String, completion: @escaping (Bool, Error?) -> Void) {
        do {
            let url = try getUrlRequest(for: [Endpoints[.me], Endpoints[.player], Endpoints[.queue]], method: .post, queries: ["uri": uri])
            self.requestWithoutBodyResponse(url: url, completion: completion)
        } catch let error {
            completion(false, error)
        }
    }
}
