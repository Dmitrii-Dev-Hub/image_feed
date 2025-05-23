import Foundation
@testable import Image_feed

final class AuthHelperFake: AuthHelperProtocol {
    func authRequest() -> URLRequest? {
        return URLRequest(url: URL(string: "https://")!)
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
