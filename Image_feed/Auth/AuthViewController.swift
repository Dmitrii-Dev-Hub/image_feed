import UIKit

class AuthViewController: UIViewController {

    private let imageView = UIImageView()
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupImageView()
        stupButton()
        setupConstraints()
        
    }
    
    private func setupImageView() {
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Vector")
        view.addSubview(imageView)
    }
    
    private func stupButton() {
        button
            .translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .ypWhite
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        view.addSubview(button)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //
            imageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(
                equalToConstant: 60),
            imageView.widthAnchor.constraint(
                equalToConstant: 60),
            
            
            
            //
            button.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(
                equalTo: view
                    .safeAreaLayoutGuide.bottomAnchor, constant: -90),
            button.heightAnchor.constraint(
                equalToConstant: 48),
            button.widthAnchor.constraint(
                equalToConstant: 343)
        ])
    }
    @objc private func openWebView() {
        let webVC = WebViewViewController()
        navigationController?.pushViewController(webVC, animated: true)
        
    }
    
}
#Preview(traits: .portrait) {
    AuthViewController()
}
