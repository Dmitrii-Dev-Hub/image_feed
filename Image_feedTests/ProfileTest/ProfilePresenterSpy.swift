import Foundation
import Image_feed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: (any Image_feed.ProfileViewControllerProtocol)?
    var isAvatarUpdated = false
    var isViewDidLoad = false
    
    func doLogoutAction() {}
    
    func updateAvatar() {
        isAvatarUpdated = true
    }
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
}
