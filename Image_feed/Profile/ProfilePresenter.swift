import Foundation


final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var logoutService: ProfileLogoutServiceProtocol
    private var profileImageService: ProfileImageServiceProtocol
    private let profileServer = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private var profileService = ProfileService.shared
    private let logOutService = ProfileLogoutService.shared
    
    init(view: ProfileViewControllerProtocol? = nil,
         logoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
         profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.view = view
        self.logoutService = logoutService
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        
        view?.configure(model: profileService.profile)
        
        profileServer.fetchProfile(bearerToken: tokenStorage.token ?? "") { result in
            
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
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        view?.setAvatar(url: url)
    }
}
