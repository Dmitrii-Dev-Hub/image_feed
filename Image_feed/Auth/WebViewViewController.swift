import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}

final class WebViewViewController: UIViewController, AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true)
    }
    
    
    //private let oauth2Service = OAuth2Service()
    private let progressView = UIProgressView()
    private let backwardButton = UIButton()
    private let webView = WKWebView()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupWebView()
        setupProgressView()
        setupBackwardButton()
        loadingWebView()
        setupConstraints()
        
        webView.navigationDelegate = self
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupProgressView() {
        progressView
            .translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .ypBlack
        view.addSubview(progressView)
    }
    
    private func setupBackwardButton() {
        backwardButton
            .translatesAutoresizingMaskIntoConstraints = false
        backwardButton.setImage(
            UIImage(named: "Backward"), for: .normal)
        backwardButton.addTarget(self, action: #selector(
            backToAuthViewController), for: .touchUpInside)
        view.addSubview(backwardButton)
    }
    
    private func setupWebView() {
        webView
            .translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
    
    private func loadingWebView() {
        guard var urlComponents = URLComponents(
            string: WebViewConstants
                .unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: "client_id", value: Constants.accessKey),
            URLQueryItem(
                name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(
                name: "response_type", value: "code"),
            URLQueryItem(
                name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backwardButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 8),
            backwardButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(
                equalToConstant: 24),
            backwardButton.heightAnchor.constraint(
                equalToConstant: 24),
            
            //
            webView.topAnchor.constraint(
                equalTo: backwardButton.bottomAnchor),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            //
            progressView.topAnchor.constraint(
                equalTo: backwardButton.bottomAnchor, constant: 0),
            progressView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide
                    .leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
            
        ])
    }
    
    
    
    @objc private func backToAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        navigationController?.pushViewController(
            authVC, animated: true)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    
    
    
    private func code(
        from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(
                string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(
                where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}

#Preview(traits: .portrait) {
    WebViewViewController()
}

