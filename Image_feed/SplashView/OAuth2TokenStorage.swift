import Foundation

final class OAuth2TokenStorage {
//    private let tokenKey = "OAuthTokenKey"
//    
//    init(){
//    }
//    
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: tokenKey)
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
//        }
//    }
    
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
