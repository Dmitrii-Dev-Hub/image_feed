import UIKit
import Kingfisher


final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    private let imageViewUserPhoto = UIImageView()
    private let exitButton = UIButton()
    private let userNameLabel = UILabel()
    private let userEmailLabel = UILabel()
    private let userGreetingsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        presenter?.viewDidLoad()
  
        setupImageView()
        setupExitButton()
        setupUserNameLabel()
        setupUserEmailLabel()
        setupUserGreetingsLabel()
        setupConstraints()
        
        view.backgroundColor = .ypBlack
        
    }
    
    func setUserNameLabel(text: String) {
        userNameLabel.text = text
    }
    
    func setUserEmailLabel(text: String) {
        userEmailLabel.text = text
    }
    
    func configure(model: Profile?) {
        userNameLabel.text = model?.name
        userEmailLabel.text = model?.loginName
        userGreetingsLabel.text = model?.bio
    }
    
    func updateAvatar() {
        presenter?.updateAvatar()
    }
    func setAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        
        imageViewUserPhoto.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .profileNoActive),
            options: [
                .processor(processor)
            ]
        )
    }
    
    @objc private func didTapExitButton() {
        let alert = UIAlertController(
            title: "Пока пока!",
            message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attributedTitle = NSAttributedString(
            string: "Пока, пока!", attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.view.accessibilityIdentifier = "Alert"
        let yesAction = UIAlertAction(
            title: "Да", style: .cancel) { _ in
                self.presenter?.doLogoutAction()
                guard let window = UIApplication
                    .shared.windows.first else { return }
                window.rootViewController = SplashViewController()
        }
        yesAction.accessibilityIdentifier = "Yes"
        let noAction = UIAlertAction(
            title: "Нет", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    

}

extension UIView {
    func addView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}
extension ProfileViewController {
    
    private func setupImageView() {
            imageViewUserPhoto
                .translatesAutoresizingMaskIntoConstraints = false
            imageViewUserPhoto.image = UIImage(named: "Photo")
            imageViewUserPhoto.clipsToBounds = true
            imageViewUserPhoto.layer.cornerRadius = 35
            view.addSubview(imageViewUserPhoto)
        }
    
    private func setupUserGreetingsLabel() {
            userGreetingsLabel
                .translatesAutoresizingMaskIntoConstraints = false
            userGreetingsLabel.text = "Hello, world!"
            userGreetingsLabel.font = UIFont.systemFont(ofSize: 13)
            userGreetingsLabel.textColor = .ypWhite
            userGreetingsLabel.textAlignment = .left
            userGreetingsLabel.numberOfLines = 0
            
            view.addSubview(userGreetingsLabel)
        }
    
    private func setupExitButton() {
            exitButton
                .translatesAutoresizingMaskIntoConstraints = false
            exitButton.accessibilityIdentifier = "logoutButton"
            exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
            exitButton.setImage(UIImage(named: "Exit"), for: .normal)
            view.addSubview(exitButton)
        }
    private func setupUserNameLabel() {
           userNameLabel
               .translatesAutoresizingMaskIntoConstraints = false
           userNameLabel.text = "Екатерина Новикова"
           userNameLabel.numberOfLines = 0
           userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
           userNameLabel.textColor = .ypWhite
           userNameLabel.textAlignment = .left
           view.addSubview(userNameLabel)
       }
    private func setupUserEmailLabel() {
            userEmailLabel
                .translatesAutoresizingMaskIntoConstraints = false
            userEmailLabel.text = "@ekaterina_nov"
            userEmailLabel.font = UIFont.systemFont(ofSize: 13)
            userEmailLabel.textColor = .ypGrey
            userEmailLabel.textAlignment = .left
            userEmailLabel.numberOfLines = 0
            view.addSubview(userEmailLabel)
        }
    
    
    
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                
                //
                imageViewUserPhoto.leadingAnchor.constraint(
                    equalTo:view.leadingAnchor,constant: 16),
                imageViewUserPhoto.topAnchor.constraint(
                    equalTo:view.topAnchor,constant: 76),
                imageViewUserPhoto.widthAnchor.constraint(
                    equalToConstant: 70),
                imageViewUserPhoto.heightAnchor.constraint(
                    equalToConstant: 70),
                
                //
                exitButton.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -24),
                exitButton.topAnchor.constraint(
                    equalTo: view.topAnchor, constant: 99),
                exitButton.widthAnchor.constraint(
                    equalToConstant: 24),
                exitButton.heightAnchor.constraint(
                    equalToConstant: 24),
                
                //
                userNameLabel.topAnchor.constraint(
                    equalTo: view.topAnchor, constant: 154),
                userNameLabel.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: 16),
                userNameLabel.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: 16),
                
                //
                userEmailLabel.topAnchor.constraint(
                    equalTo: userNameLabel.bottomAnchor, constant: 8),
                userEmailLabel.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: 16),
                userEmailLabel.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: 16),
                
                //
                userGreetingsLabel
                    .leadingAnchor.constraint(
                        equalTo: view.leadingAnchor, constant: 16),
                userGreetingsLabel.topAnchor.constraint(
                    equalTo: userEmailLabel.bottomAnchor, constant: 8),
                userGreetingsLabel.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: 16),
            ])
        }
}
//#Preview(traits: .portrait) {
//    ProfileViewController()
//}


