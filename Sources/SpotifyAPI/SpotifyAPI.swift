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
    
    func getUser(completion: @escaping (UserPublic?, String?) -> Void) {
        assert(authClient != nil, "Spotify manager not initialzed, call initialize() before use")
        
        let url = baseUrl.appendingPathComponent(Endpoints[.me])
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authClient!.accessToken!)"
        ]
        
        authClient!.authorize {_,_ in
        AF.request(url, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let decoded = try decoder.decode(UserPublic.self, from: data!)
                            completion(decoded, nil)
                            
                        } catch {
                            completion(nil, error.localizedDescription)
                        }
                        
                    case .failure(let error):
                        completion(nil, error.localizedDescription)
                }
            }
        }
    }
}
