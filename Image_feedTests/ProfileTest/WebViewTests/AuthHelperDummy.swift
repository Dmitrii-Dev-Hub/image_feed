import Foundation
@testable import Image_feed

final class AuthHelperDummy: AuthHelperProtocol {
    func authRequest() -> URLRequest? { return nil }
    func code(from url: URL) -> String? { return nil }
}
