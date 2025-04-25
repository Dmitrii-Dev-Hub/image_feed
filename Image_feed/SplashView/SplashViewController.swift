
import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNextScreen()
    }
    
    private func showNextScreen() {
        if (OAuth2TokenStorage().token?.isEmpty) != nil {
            switchToTabBarController()
        } else {
            let authViewController = AuthViewController()
            let navigationController = UINavigationController(rootViewController: authViewController)
            
            navigationController.modalPresentationStyle = .fullScreen
            authViewController.delegate = self
            present(navigationController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
    }
    
    
    private func switchToImagesListViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let imagesListViewController = ImagesListViewController()
        let navigationController = UINavigationController(rootViewController: imagesListViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
                    
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}
