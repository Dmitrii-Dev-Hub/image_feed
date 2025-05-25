import UIKit
import ProgressHUD

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    weak var delegate: AuthViewControllerDelegate?
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let alertPresenter = AlertPresenter()
    private let oauth2Service = OAuth2Service.shared
    private let oauth2ServiceStory = OAuth2TokenStorage()
    private let imageView = UIImageView()
    private var button = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupImageView()
        setupButton()
        setupConstraints()
        
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        self.navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            navigationController?.popViewController(animated: true)
            switch result {
            case .success(let bearerToken):
                oauth2ServiceStory.token = bearerToken
                delegate?.didAuthenticate(self)
                
            case .failure(let error):
                print("failure with error - \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Что-то пошло не так",
                        message: "Не удалось войти в систему",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupImageView() {
        imageView
            .translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .vector)
        view.addSubview(imageView)
    }
    
    private func setupButton() {
        button = UIButton(type: .system)
        button
            .translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "Authenticate"
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .ypWhite
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.textAlignment = .center
        button.addTarget(
            self, action: #selector(openWebView),
            for: .touchUpInside)
        view.addSubview(button)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //
            imageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
//            imageView.heightAnchor.constraint(
//                equalToConstant: 60),
//            imageView.widthAnchor.constraint(
//                equalToConstant: 60),
            
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
        ])
    }
    @objc private func openWebView() {
        let webViewController = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewController
        webViewController.delegate = self
        webViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
    
}



//#Preview(traits: .portrait) {
//    AuthViewController()
//}
