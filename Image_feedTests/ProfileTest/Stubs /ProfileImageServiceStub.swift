import Foundation
import Image_feed

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    static var shared: any Image_feed.ProfileImageServiceProtocol = ProfileImageServiceStub()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChangeStub")
    
    var avatarURL: String? = "http://"
    
    func clearBeforeLogout() { }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, any Error>) -> Void) {
        avatarURL = "http://"
    }
}
