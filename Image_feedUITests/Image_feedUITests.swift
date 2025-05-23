import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        print(app.debugDescription)
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        sleep(3)
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        sleep(3)
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("Login")
        dismissKeyboardIfPresent()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Password")
        dismissKeyboardIfPresent()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
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
        XCTAssertTrue(app.staticTexts["Dmitry_bauzhadze@mail.ru"].exists)
        
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

