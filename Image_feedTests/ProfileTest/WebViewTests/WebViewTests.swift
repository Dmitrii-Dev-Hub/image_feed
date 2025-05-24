@testable import Image_feed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given

        let viewController = WebViewViewController()
          let presenter = WebViewPresenterSpy()
          presenter.view = viewController
          viewController.presenter = presenter

        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelperFake()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.loadIsCalled)
    }
    
    func testShouldHideProgress() {
        // given
        let authHelper = AuthHelperDummy()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: 1)
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let helper = AuthHelper(configuration: configuration)
        
        //when
        let url = helper.authURL()
        let urlString = url?.absoluteString
        
        //then
        XCTAssertEqual(urlString?.contains(configuration.authURLString), true)
        XCTAssertEqual(urlString?.contains(configuration.accessKey), true)
        XCTAssertEqual(urlString?.contains(configuration.redirectURI), true)
        XCTAssertEqual(urlString?.contains("code"), true)
        XCTAssertEqual(urlString?.contains(configuration.accessScope), true)
    }
    
    func testCodeFromURL() {
        // given
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        components?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = components?.url
        
        let helper = AuthHelper()
        
        // when
        var code: String = ""
        if let url = url {
            code = helper.code(from: url) ?? ""
        } else {
            XCTFail("url is nil")
        }
        
        // then
        XCTAssertEqual(code, "test code")
        
    }
}
