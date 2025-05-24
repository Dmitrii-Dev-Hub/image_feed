import Foundation

public protocol ProfileImageServiceProtocol {
    static var shared: ProfileImageServiceProtocol { get }
    static var didChangeNotification: Notification.Name { get }
    
    var avatarURL: String? { get }
    
    func clearBeforeLogout()
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void)
}
