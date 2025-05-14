import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    
    var token: String? {
           get {
               guard let token = KeychainWrapper.standard.string(forKey: Constants.Keys.bearerTokenKey) else {
                   print("Bearer token isn't string")
                   return KeychainWrapper.standard.string(forKey: Constants.Keys.bearerTokenKey)
               }
               
               return token
           }
           
           set {
               KeychainWrapper.standard.set(newValue ?? "", forKey: Constants.Keys.bearerTokenKey)
           }
       }
}



//
//    static let shared = OAuth2TokenStorage()
//
//    private let keychainKey = "OAuthTokenKey"
//
//    var token: String? {
//        get {
//            guard let token = KeychainWrapper.standard.string(forKey:keychainKey) else {
//                print("Bearer token isn't string")
//                return KeychainWrapper.standard.string(forKey: keychainKey)
//            }
//
//            return token
//        }
//        set {
//            KeychainWrapper.standard.set(newValue ?? "", forKey: keychainKey)
//        }
//    }
