
import UIKit


final class TabBarViewController: UITabBarController {
    
    private let imagesListViewController = ImagesListViewController()
    private let profileViewController = ProfileViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarImage()
        setupImagesListViewController()
        setupProfileViewController()
        
        setViewControllers([imagesListViewController,
                            profileViewController,
                           ], animated: true)
    }
    
    private func setupTabBarImage(){
        tabBar.barStyle = .black
        tabBar.backgroundColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypTabBarColorNoActive
    }
    
    private func setupImagesListViewController(){
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "EditorialNoActive"),
            selectedImage: UIImage(named: "EditorialActive")
        )
    }
    
    private func setupProfileViewController(){
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ProfileNoActive"),
            selectedImage: UIImage(named: "ProfileActive")
        )
    }
}

