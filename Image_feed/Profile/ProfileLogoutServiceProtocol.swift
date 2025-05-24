import Foundation

public protocol ProfileLogoutServiceProtocol {
    static var shared: ProfileLogoutServiceProtocol { get }
    func logout()
}
