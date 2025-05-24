import Foundation

public protocol ProfileServiceProtocol {
    static var shared: ProfileServiceProtocol { get }
    
    var profile: Profile? { get }
    
    func clearBeforeLogout()
    func fetchProfile(bearerToken: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

