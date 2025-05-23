import Foundation


final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileServer = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let logOutService = ProfileLogoutService.shared
    
    init(view: ProfileViewProtocol? = nil) {
        self.view = view
      
    }
    
    func viewDidLoad() {
        
        view?.configure(model: profileService.profile)
        
        profileServer.fetchProfile(tokenStorage.token ?? "") { result in
            
            switch result {
            case .success(let profile):
                self.view?.setUserNameLabel(text: profile.name)
                self.view?.setUserEmailLabel(text: profile.loginName)
                print(profile)
            case .failure(_):
                print("")
            }
            
        }
        profileImageServiceObserver = NotificationCenter.default
                   .addObserver(
                       forName: ProfileImageService.didChangeNotification,
                       object: nil,
                       queue: .main
                   ) { [weak self] _ in
                       guard let self = self else { return }
                       self.updateAvatar()
                   }
               updateAvatar()
    }
    
    
    func doLogoutAction() {
        logOutService.logout()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(url: url)
    }
}
