import Foundation
import Image_feed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: ProfilePresenterProtocol?
    var isAvatarSet = false
    var isConfigure = false
    var isAvatarImageUpdated = false
    var receivedUserName: String?
    var receivedUserEmail: String?

    func setAvatar(url: URL) {
        isAvatarSet = true
        isAvatarImageUpdated = true
    }
    
    func configure(model: Image_feed.Profile?) {
        isConfigure = true
    }

    func configure(for profile: Profile) {
        isConfigure = true
    }

    func updateAvatar() {
        isAvatarImageUpdated = true
    }
    
    func setUserNameLabel(text: String) {
        receivedUserName = text
    }
    
    func setUserEmailLabel(text: String) {
        receivedUserEmail = text
    }
}
