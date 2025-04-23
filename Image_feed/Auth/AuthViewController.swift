import UIKit

class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        self.navigationController?.popViewController(animated: true)
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
                   guard let self = self else { return }
                   self.navigationController?.popViewController(animated: true)
                   
                   switch result {
                   case .success(let bearerToken):
                       self.oauth2TokenStorage.token = bearerToken
                       delegate?.didAuthenticate(self)
                   case .failure(let error):
                       print("failure with error - \(error)")
                   }
               }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    private let imageView = UIImageView()
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupImageView()
        setupButton()
        setupConstraints()
        
    }
    
    private func setupImageView() {
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Vector")
        view.addSubview(imageView)
    }
    
    private func setupButton() {
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
            //button.widthAnchor.constraint(
                //equalToConstant: 343)
        ])
    }
    @objc private func openWebView() {
        let webVC = WebViewViewController()
        webVC.delegate = self
        navigationController?.pushViewController(webVC, animated: true)
        
    }
    
}
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


//extension AuthViewController: WebViewViewControllerDelegate {
//    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
////        vc.dismiss(animated: true) // Закрыли WebView
//
//        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
//            // TODO: разберите полученный ответ с помощью оператора switch
//        }
//    }
//    
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
//        dismiss(animated: true)
//    }
//}

#Preview(traits: .portrait) {
    AuthViewController()
}
