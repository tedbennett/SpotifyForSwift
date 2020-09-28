import Alamofire
import OAuth2
import Foundation

public class SpotifyAPI {
    var authClient: OAuth2CodeGrant?
    
    static let manager = SpotifyAPI()
    
    private init() {}
    
    func initialize(clientId: String, redirectUris: [String], scopes: [AuthScope], usePkce: Bool = true, useKeychain: Bool = true) {
        authClient = OAuth2CodeGrant(settings: [
            "client_id": clientId,
            "authorize_uri": "https://accounts.spotify.com/authorize",
            "token_uri": "https://accounts.spotify.com/api/token",
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
    
    func getOwnUserProfile(completion: @escaping (UserPublic?, Error?) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        
        authClient!.authorize { (_,_) in
            let url = baseUrl.appendingPathComponent(Endpoints[.me])
            var request = URLRequest(url: url)
            request.setValue("Bearer \(self.authClient!.accessToken!)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                    let decoded = try decoder.decode(UserPublic.self, from: data)
                    completion(decoded, nil)
                } catch let parseError {
                    completion(nil, parseError)
                }
            }.resume()
        }
    }
}
