import Foundation
import KeychainSwift

public class SpotifyAPI {
    public static let manager = SpotifyAPI()
    
    private init() {
        _ = loadFromKeychain()
    }
    
    private var userId: String?
    private var pkceParams: PkceParams?
    private var auth: AuthParams?
    
    // MARK: - Auth
    
    public func getAuthUrl(clientId: String, scopes: [AuthScope], redirect: String) -> URL? {
        let verifier = getVerifier()
        
        pkceParams = PkceParams(verifier: verifier, clientId: clientId, redirectUri: redirect)
        
        let challenge = getChallenge(verifier: verifier)
        var components = URLComponents(string: authUrl)!
        
        let queries = [
            "client_id": clientId,
            "redirect_uri": redirect,
            "code_challenge_method": "S256",
            "code_challenge": challenge,
            "response_type": "code",
            "scope": scopes.map{scope in scope.rawValue}.joined(separator: "%20")
        ]
        
        components.queryItems = queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        return components.url
    }
    
    public func handleRedirect(redirectUrl: URL, completion: @escaping (Bool) -> Void) {
        guard let components = URLComponents(url: redirectUrl, resolvingAgainstBaseURL: true), let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
              let params = pkceParams else {
            completion(false)
            return
        }
        
        let headers = ["content-type": "application/x-www-form-urlencoded"]
        
        let postData = NSMutableData(data: "grant_type=authorization_code".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(params.clientId)".data(using: String.Encoding.utf8)!)
        postData.append("&code_verifier=\(params.verifier)".data(using: String.Encoding.utf8)!)
        postData.append("&code=\(code)".data(using: String.Encoding.utf8)!)
        postData.append("&redirect_uri=\(params.redirectUri)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: URL(string: tokenUrl)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                print(error.debugDescription)
                completion(false)
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self.auth = AuthParams(json: json)
                
                self.getOwnUserProfile { profile, error in
                    guard let profile = profile else {
                        completion(false)
                        return
                    }
                    self.userId = profile.id
                    self.saveToKeychain()
                    completion(true)
                }
            }
            
        }.resume()
    }
    
    public func forgetTokens() {
        pkceParams = nil
        auth = nil
        clearKeychain()
    }
    
    public func isAuthorised() -> Bool {
        return auth != nil
    }
    
    private func saveToKeychain() {
        guard let auth = auth, let userId = userId else {
            return
        }
        let keychain = KeychainSwift()
        keychain.set(auth.accessToken, forKey: "spotify-access-token")
        keychain.set(auth.refreshToken, forKey: "spotify-refresh-token")
        keychain.set("\(auth.expiry.timeIntervalSince1970)", forKey: "spotify-expiry")
        keychain.set(userId, forKey: "spotify-user-id")
    }
    
    private func loadFromKeychain() -> Bool {
        let keychain = KeychainSwift()
        guard let accessToken = keychain.get("spotify-access-token"),
            let refreshToken = keychain.get("spotify-refresh-token"),
            let expiry = keychain.get("spotify-expiry"),
            let userId = keychain.get("spotify-user-id"),
            let seconds = Int(expiry) else {
            return false
        }
        
        let expiresAt = Date(timeIntervalSince1970: TimeInterval(seconds))
        
        auth = AuthParams(accessToken: accessToken, refreshToken: refreshToken, expiry: expiresAt)
        self.userId = userId
        return true
    }
    
    private func clearKeychain() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
}

// MARK: - Requests

extension SpotifyAPI {
    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let auth = auth, let params = pkceParams else {
            completion(false)
            return
        }
        
        let headers = ["content-type": "application/x-www-form-urlencoded"]
        
        let postData = NSMutableData(data: "grant_type=authorization_code".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(params.clientId)".data(using: String.Encoding.utf8)!)
        postData.append("&grant_type=refresh_token".data(using: String.Encoding.utf8)!)
        postData.append("&refresh_token=\(auth.refreshToken)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: URL(string: tokenUrl)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                print(error.debugDescription)
                completion(false)
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self.auth = AuthParams(json: json)
                completion(true)
            }
            
        }.resume()
    }
    
    func request<Object: Codable>(url: URLRequest, completion: @escaping (Object?, Error?) -> Void) {
        let signedUrl = getSignedUrl(from: url)
        URLSession.shared.dataTask(with: signedUrl) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 429, let retryDelay = response.value(forHTTPHeaderField: "Retry-After") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryDelay)!) {
                        self.request(url: url, completion: completion)
                    }
                    return
                } else if response.statusCode == 401 {
                    self.refreshToken { success in
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
        let signedUrl = getSignedUrl(from: url)
        URLSession.shared.dataTask(with: signedUrl) { (data, response, error) in
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
                        self.refreshToken { success in
                            if success {
                                self.requestWithoutBodyResponse(url: url, completion: completion)
                            }
                        }
                        return
                    case 200, 201, 202, 204:
                        completion(true, nil)
                        return
                    case 403:
                        completion(false, ApiError.invalidScope)
                    case 404:
                        completion(false, ApiError.notFound)
                    default:
                        completion(false, ApiError.unknown)
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
    
    func paginatedRequest<Object: Codable>(url: URLRequest, requiresUserAccess: Bool = false, objects: [Object] = [], completion: @escaping ([Object], Error?) -> Void) {
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
                let nextUrl = URLRequest(url: next)
                self.paginatedRequest(url: nextUrl, requiresUserAccess: requiresUserAccess, objects: newObjects, completion: completion)
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
    func getUrlRequest(for paths: [String], method: HTTPMethod = .get, queries: [String:String] = [:]) -> URLRequest {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = queries.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard var url = components.url else {
            fatalError("Failed to create url request")
        }
        
        paths.forEach { path in
            url.appendPathComponent(path)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    func getSignedUrl(from url: URLRequest) -> URLRequest {
        var signedUrl = url
        if let auth = auth {
            signedUrl.addValue("Bearer \(auth.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return signedUrl
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
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me]])
        request(url: url, completion: completion)
    }
}

// MARK: - Playlists

extension SpotifyAPI {
    
    public func getPlaylist(id: String, completion: @escaping (Playlist?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id])
        request(url: url, completion: completion)
    }
    
    // needs playlist-read-private or playlist-read-collaborative for private/collaborative playlists
    public func getOwnPlaylists(completion: @escaping ([PlaylistSimplified], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.playlists]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    // needs playlist-read-private or playlist-read-collaborative for private/collaborative playlists
    public func getUsersPlaylists(id: String? = nil, completion: @escaping ([PlaylistSimplified], Error?) -> Void) {
        guard let id = id ?? userId else {
            completion([], ApiError.noUserId)
            return
        }
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.users], id, Endpoints[.playlists]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    public func getPlaylistsTracks(id: String, country: String, completion: @escaping ([PlaylistTrackWrapper], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.tracks]], queries: ["market": country, "limit": "50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    public func getPlaylistImages(id: String, completion: @escaping ([Image]?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.images]])
        request(url: url, completion: completion)
    }
    
    public func createPlaylist(userId: String?, name: String, description: String?, isPublic: Bool, collaborative: Bool, completion: @escaping (Playlist?, Error?) -> Void) {
        guard let id = userId ?? self.userId else {
            completion(nil, ApiError.noUserId)
            return
        }
        var url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.users], id, Endpoints[.playlists]], method: .post)
        
        url.httpBody = requestBody(from: ["name": name, "description": description, "public": isPublic, "collaborative": collaborative])
        
        request(url: url, completion: completion)
        
    }
    
    public func addTracksToPlaylist(id: String, uris: [String], completion: @escaping (Bool, Error?) -> Void) {
        var url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id, Endpoints[.tracks]], method: .post)
        // limited to 100 tracks per request
        
        let chunkedUris = uris.chunked(into: 100)
        
        for chunk in chunkedUris {
            url.httpBody = requestBody(from: ["uris": chunk])
            
            requestWithoutBodyResponse(url: url, completion: completion)
        }
    }
    
    public func createPlaylist(userId: String? = nil, name: String, description: String, uris: [String], isPublic: Bool, collaborative: Bool, completion: @escaping (Bool, Error?) -> Void) {
        guard let id = userId ?? self.userId else {
            completion(false, ApiError.noUserId)
            return
        }
        createPlaylist(userId: id, name: name, description: description, isPublic: isPublic, collaborative: collaborative) { playlist, error in
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
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.tracks], id])
        request(url: url, completion: completion)
    }
    
    public func getTracks(ids: [String], completion: @escaping ([Track?]?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.tracks]], queries:  ["ids": ids.joined(separator: ",")])
        arrayRequest(url: url, key: "tracks", completion: completion)
    }
}

// MARK: - Albums

extension SpotifyAPI {
    
    public func getAlbum(id: String, completion: @escaping (Album?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums], id])
        request(url: url, completion: completion)
    }
    
    public func getAlbums(ids: [String], completion: @escaping ([Album?]?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums]], queries:  ["ids": ids.joined(separator: ",")])
        arrayRequest(url: url, key: "albums", completion: completion)
    }
    
    public func getAlbumsTracks(id: String, completion: @escaping ([TrackSimplified], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums], id, Endpoints[.tracks]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
}

// MARK: - Artists

extension SpotifyAPI {
    
    public func getArtist(id: String, completion: @escaping (Artist?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id])
        request(url: url, completion: completion)
    }
    
    public func getArtists(ids: [String], completion: @escaping ([Artist?]?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists]], queries:  ["ids": ids.joined(separator: ",")])
        arrayRequest(url: url, key: "artists", completion: completion)
    }
    
    public func getArtistsAlbums(id: String, completion: @escaping ([AlbumSimplified], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.albums]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    public func getArtistsTopTracks(id: String, country: String, completion: @escaping ([Track]?, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.topTracks]], queries: ["market": country])
        arrayRequest(url: url, key: "tracks", completion: completion)
    }
    
    public func getArtistsRelatedArtists(id: String, completion: @escaping ([Artist]?, Error?) -> Void) {
        let url =  SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.relatedArtists]])
        arrayRequest(url: url, key: "artists", completion: completion)
    }
}

// MARK: - Library

extension SpotifyAPI {
    
    // requires user-library-read
    public func getLibraryAlbums(completion: @escaping ([SavedAlbum], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.albums]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    // requires user-library-read
    public func getLibraryTracks(completion: @escaping ([SavedTrack], Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.tracks]], queries: ["limit":"50"])
        paginatedRequest(url: url, completion: completion)
    }
    
    // requires user-library-modify
    public func addTracksToLibrary(ids: [String], completion: @escaping (Bool, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.tracks]], method: .put, queries: ["ids": ids.joined(separator: ",")])
        requestWithoutBodyResponse(url: url, completion: completion)
    }
    
    // requires user-library-modify
    public func addAlbumsToLibrary(ids: [String], completion: @escaping (Bool, Error?) -> Void) {
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me], Endpoints[.albums]], method: .put, queries: ["ids": ids.joined(separator: ",")])
        requestWithoutBodyResponse(url: url, completion: completion)
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
        
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.search]], queries: ["q": queryString, "type": type])
        singlePageRequest(url: url, key: "\(type)s", completion: completion)
    }
    
    public func getTrackFromIsrc(_ isrc: String, completion: @escaping ([Track], URL?, Error?) -> Void) {
        let type = SearchType[.track]
        let url = SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.search]], queries: ["q": "isrc:\(isrc)", "type": type, "limit":"1"])
        singlePageRequest(url: url, key: "\(type)s", completion: completion)
    }
}

// MARK: - Queue

extension SpotifyAPI {
    public func addTrackToQueue(uri: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = getUrlRequest(for: [Endpoints[.me], Endpoints[.player], Endpoints[.queue]], method: .post, queries: ["uri": uri])
        requestWithoutBodyResponse(url: url, completion: completion)
    }
}
