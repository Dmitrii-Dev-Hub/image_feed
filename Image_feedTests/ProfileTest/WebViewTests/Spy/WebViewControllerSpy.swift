import UIKit
import Image_feed

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: Image_feed.WebViewPresenterProtocol?
    var loadIsCalled = false
    
    func load(request: URLRequest) {
        loadIsCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
