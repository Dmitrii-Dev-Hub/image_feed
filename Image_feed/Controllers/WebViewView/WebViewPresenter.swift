import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewControllerProtocol?
    var authHelper: AuthHelperProtocol?
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper?.authRequest() else {
            print("Cannot construct request for WebView")
            return
        }
        view?.load(request: request)
    }
    
    func updateProgressValue(_ value: Double) {
        let valueTypeFloat = Float(value)
        let shouldHideProgress = shouldHideProgress(for: valueTypeFloat)
        
        view?.setProgressValue(valueTypeFloat)
        view?.setProgressHidden(shouldHideProgress)
    }
   
    func code(from url: URL) -> String? {
        authHelper?.code(from: url)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        return abs(value - 1.0) <= 0.0001
    }
}
