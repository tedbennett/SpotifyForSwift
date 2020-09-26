import Alamofire
import OAuth2

class SpotifyAPI {
    var authClient = OAuth2CodeGrant(settings: [
        "client_id": "e164f018712e4c6ba906a595591ff010",
        "authorize_uri": "https://accounts.spotify.com/authorize",
        "token_uri": "https://accounts.spotify.com/api/token",
        "redirect_uris": ["music-manager://oauth-callback/"],
        "use_pkce": true,
        "scope": "playlist-read-private%20playlist-modify-private",
        "keychain": true,
    ] as OAuth2JSON)
    
    lazy var loader = OAuth2DataLoader(oauth2: authClient)
    
    static let shared = SpotifyAPI()
    
    private init() {}

    func authorize(completion: @escaping (Bool) -> Void) {
        self.authClient.forgetTokens()
        authClient.authorize(callback: {authParameters, error in
            if authParameters != nil {
                completion(true)
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")
                // error will not be nil
                if error?.description == "Refresh token revoked" {
                    self.authClient.forgetTokens()
                }
                completion(false)
            }
            
        })
        
    }
    
    func decode() {
        
    }
}
