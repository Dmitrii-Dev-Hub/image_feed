
import UIKit


final class TabBarViewController: UITabBarController {
    
    private let imagesListViewController = ImagesListViewController()
    private let profileViewController = ProfileViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarImage()
        
//        let imagesListVC = ImagesListViewController()
//        imagesListVC.presenter = ImagesListPresenter(view: imagesListVC)
//        setupImagesListViewController()
//        
//        let profileVC = ProfileViewController()
//        profileVC.presenter = ProfilePresenter(view: profileVC)
//        setupProfileViewController()
//        
//        setViewControllers([imagesListVC, profileVC], animated: true)
        
        setupImagesListViewController()
        setupProfileViewController()
        
        let profilePresenter = ProfilePresenter(view: profileViewController)
        profileViewController.presenter = profilePresenter
        
        let imagesListPresenter = ImagesListPresenter(view: imagesListViewController)
        imagesListViewController.presenter = imagesListPresenter
//        let imagesListVC = ImagesListViewController()
//        imagesListVC.presenter = ImagesListPresenter(view: imagesListVC)
        
        
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

