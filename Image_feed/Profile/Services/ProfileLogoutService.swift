import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    static let shared: ProfileLogoutServiceProtocol = ProfileLogoutService()
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let imagesListService = ImagesListService.shared
    
    private init() { }
    
    func logout() {
        cleanCookies()
        KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(
            rawValue: Constants.Keys.bearerTokenKey))
        profileImageService.clearBeforeLogout()
        profileService.resetProfile()
        imagesListService.clearBeforeLogout()
        
        switchToSplashController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let splashViewController = SplashViewController()
        
        window.rootViewController = splashViewController
    }
}
