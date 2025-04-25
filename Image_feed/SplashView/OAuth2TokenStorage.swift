import Foundation

final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: "OAuthTokenKey") else {
                print("Bearer token isn't string")
                return UserDefaults.standard.string(forKey: "OAuthTokenKey")
            }
            
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "OAuthTokenKey")
        }
    }
}
