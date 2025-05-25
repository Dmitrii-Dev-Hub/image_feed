@testable import Image_feed
import XCTest

final class ProfileTests: XCTestCase {
    func testPresenterCallsSetAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: viewController,
                                   logoutService: ProfileLogoutServiceStub.shared,
                                   profileService: ProfileServiceStub.shared,
                                   profileImageService: ProfileImageServiceStub.shared)
        viewController.presenter = presenter
        
        // when
        presenter.updateAvatar()
        
        // then
        XCTAssertTrue(viewController.isAvatarSet)
    }
    
    func testPresenterCallsConfigure() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: viewController,
                                   logoutService: ProfileLogoutServiceStub.shared,
                                   profileService: ProfileServiceStub.shared,
                                   profileImageService: ProfileImageServiceStub.shared)
        viewController.presenter = presenter
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.isConfigure)
    }
    
    func testPresenterCallsAvatarImageUpdate() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: viewController,
                                   logoutService: ProfileLogoutServiceStub.shared,
                                   profileService: ProfileServiceStub.shared,
                                   profileImageService: ProfileImageServiceStub.shared)
        viewController.presenter = presenter
        
        // when
        presenter.viewDidLoad()

        
        // then
        XCTAssertTrue(viewController.isAvatarImageUpdated)
    }
    
    func testControllerCallsUpdateAvatar() {
        // given
        let controller = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        controller.presenter = presenter
        presenter.view = controller
        
        // when
        controller.updateAvatar()
        
        // then
        XCTAssertTrue(presenter.isAvatarUpdated)
    }
    
    func testControllerCallsViewDidLoad() {
        // given
        let controller = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        controller.presenter = presenter
        presenter.view = controller
        
        // when
        _ = controller.view
        
        // then
        XCTAssertTrue(presenter.isViewDidLoad)
    }
    
    func testDoLogoutAction() {
        // given
        let presenter = ProfilePresenter()
        
        // when
        presenter.doLogoutAction()
        
        // then
        XCTAssertNil(ProfileImageService.shared.avatarURL)
        XCTAssertNil(ProfileService.shared.profile)
        XCTAssertTrue(ImagesListService.shared.photos.isEmpty)
    }
}
