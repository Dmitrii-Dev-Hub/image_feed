import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    func pasteText(_ text: String, into element: XCUIElement) {
        UIPasteboard.general.string = text
        element.press(forDuration: 1.2)
        
        let pasteMenuItem = XCUIApplication().menuItems["Paste"]
        if pasteMenuItem.waitForExistence(timeout: 2) {
            pasteMenuItem.tap()
        }
    }
    
    override func tearDownWithError() throws {
        print(app.debugDescription)
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 15))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 15))
        
        loginTextField.tap()
        pasteText("dmitry_bauzhadze@mail.ru", into: loginTextField)
        dismissKeyboardIfPresent()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 15))
        
        passwordTextField.tap()
        pasteText("Qazxswedcvb1", into: passwordTextField)
        dismissKeyboardIfPresent()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }

    
//    func testAuth() throws {
//        app.buttons["Authenticate"].tap()
//        
//        let webView = app.webViews["UnsplashWebView"]
//
//        XCTAssertTrue(webView.waitForExistence(timeout: 15))
// 
//        let loginTextField = webView.descendants(matching: .textField).element
//        XCTAssertTrue(loginTextField.waitForExistence(timeout: 15))
//        
//        loginTextField.tap()
//        loginTextField.typeText("dmitry_bauzhadze@mail.ru")
//        dismissKeyboardIfPresent()
//        
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 15))
//        passwordTextField.tap()
//        passwordTextField.typeText("Qazxswedcvb1")
//        dismissKeyboardIfPresent()
//        webView.buttons["Login"].tap()
//        let tablesQuery = app.tables
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        
//        XCTAssertTrue(cell.waitForExistence(timeout: 15))
//    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(3)
        
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(4)
        
        cellToLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["BackToImagesListButton"]
        navBackButton.tap()
        
        let cellAfterLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        XCTAssertTrue(cellAfterLike.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        sleep(3)
        
        let tab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(tab.waitForExistence(timeout: 15))
        tab.tap()
        
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["Dmitrii Bauzhadze"].exists)
        XCTAssertTrue(app.staticTexts["@dmitriibau"].exists)
        
        app.buttons["logoutButton"].tap()
        app.alerts["Alert"].scrollViews.otherElements.buttons["Yes"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
    
    private func dismissKeyboardIfPresent() {
           if app.keyboards.element(boundBy: 0).exists {
               if UIDevice.current.userInterfaceIdiom == .pad {
                   app.keyboards.buttons["Hide keyboard"].tap()
               } else {
                   app.toolbars.buttons["Done"].tap()
               }
           }
       }
}

