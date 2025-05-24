
import Foundation
import Image_feed

final class ProfileLogoutServiceStub: ProfileLogoutServiceProtocol {
    static var shared: any Image_feed.ProfileLogoutServiceProtocol = ProfileLogoutServiceStub()
    
    func logout() { }
}
