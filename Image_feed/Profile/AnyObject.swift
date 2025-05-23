import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    func setUserNameLabel(text: String)
    func setUserEmailLabel(text: String)
    func configure(model: Profile?)
    func setAvatar(url: URL)
}

