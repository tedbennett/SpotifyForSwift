import Alamofire
import OAuth2
import Foundation

public class SpotifyAPI {
    var authClient: OAuth2CodeGrant?
    
    static let manager = SpotifyAPI()
    
    private init() {}
    
    // MARK: - Auth
    
    func initialize(clientId: String, redirectUris: [String], scopes: [AuthScope], usePkce: Bool = true, useKeychain: Bool = true) {
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
    
    func authorize(completion: @escaping (Bool) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        authClient!.forgetTokens()
        authClient!.authorize(callback: {authParameters, error in
            if authParameters != nil {
                completion(true)
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
    
    // MARK: - Requests
    
    func request<Object: Codable>(url: URLRequest, completion: @escaping (Object?, Error?) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        
        //authClient!.authorize { (_,_) in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 429, let retryDelay = response.value(forHTTPHeaderField: "Retry-After"){
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryDelay)!) {
                            self.request(url: url, completion: completion)
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
                    let decoded = try decoder.decode(SpotifyError.self, from: data)
                    completion(nil, NSError(domain: decoded.message, code: decoded.status, userInfo: nil))
                    return
                } catch {}
                
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
        //}
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
                let nextUrl = self.getAuthenticatedUrl(url: next)
                self.paginatedRequest(url: nextUrl, objects: newObjects, completion: completion)
            } else {
                completion(newObjects, error)
            }
        }
    }
    
    // MARK: - Users
    
    func getOwnUserProfile(completion: @escaping (UserPublic?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.me]])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    // MARK: - Playlists
    
    func getPlaylist(id: String, completion: @escaping (Playlist?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.playlists], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    func getUserPlaylists(id: String, completion: @escaping ([PlaylistSimplified], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.users], id, Endpoints[.playlists]])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    // MARK: - Tracks
    
    func getTrack(id: String, completion: @escaping (Track?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.tracks], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    // MARK: - Albums
    
    func getAlbum(id: String, completion: @escaping (Album?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.albums], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    // MARK: - Artists
    
    func getArtist(id: String, completion: @escaping (Artist?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id])
            request(url: url, completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    func getArtists(ids: [String], completion: @escaping ([Artist]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists]], queries:  ["ids": ids.joined(separator: ",")])
            arrayRequest(url: url, key: "artists", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    func getArtistsAlbums(id: String, completion: @escaping ([AlbumSimplified], Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.albums]])
            paginatedRequest(url: url, completion: completion)
        } catch let error {
            completion([], error)
        }
    }
    
    func getArtistsTopTracks(id: String, country: String, completion: @escaping ([Track]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.topTracks]], queries: ["market": country])
            arrayRequest(url: url, key: "tracks", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    func getArtistsRelatedArtists(id: String, completion: @escaping ([Artist]?, Error?) -> Void) {
        do {
            let url = try SpotifyAPI.manager.getUrlRequest(for: [Endpoints[.artists], id, Endpoints[.relatedArtists]])
            arrayRequest(url: url, key: "artists", completion: completion)
        } catch let error {
            completion(nil, error)
        }
    }
    
    // MARK: - URL Handling
    
    func getUrlRequest(for paths: [String], queries: [String:String] = [:]) throws -> URLRequest  {
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
        return getAuthenticatedUrl(url: url)
    }
    
    func getAuthenticatedUrl(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(self.authClient!.accessToken!)", forHTTPHeaderField: "Authorization")
        return request
    }
}
