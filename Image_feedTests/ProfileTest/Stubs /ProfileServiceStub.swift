import Foundation
import Image_feed

final class ProfileServiceStub: ProfileServiceProtocol {
    static var shared: any Image_feed.ProfileServiceProtocol = ProfileServiceStub()
    
    var profile: Image_feed.Profile? = Profile()
    
    func clearBeforeLogout() { }
    
    func fetchProfile(bearerToken: String, completion: @escaping (Result<Image_feed.Profile, any Error>) -> Void) {
        profile = Profile()
    }
    
    
}
