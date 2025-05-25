import XCTest
@testable import Image_feed

final class ImagesListTests: XCTestCase {
    func testGetPhotosCount() {
        // given
        let presenter = ImagesListPresenter()
        // when
        let count = presenter.getPhotosCount()
        
        // then
        XCTAssertEqual(count, 0)
    }
    
    func testGetPhoto() {
        // given
        let service = ImagesListServiceStub()
        service.clearBeforeLogout()
        let presenter = ImagesListPresenter(view: nil, imagesListService: service)
        
        // when
        let (_, _) = presenter.updatePhotosAndGetCounts()
        let photo = presenter.getPhoto(at: 0)
        XCTAssertTrue(photo?.id == "0")
    }
    
    func testUpdatePhotosAndGetCounts() {
        // given
        let service = ImagesListServiceStub()
        service.clearBeforeLogout()
        let presenter = ImagesListPresenter(view: nil, imagesListService: service)
        
        // when
        let (old, new) = presenter.updatePhotosAndGetCounts()
        
        // then
        XCTAssertEqual(old, 0)
        XCTAssertEqual(new, 1)
    }
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
           let presenter = ImagesListPresenterSpy()
           presenter.view = viewController
           viewController.presenter = presenter
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.isViewDidLoad)
    }
    
    func testViewControllerCallsUpdatePhotos() {
        // given
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewControllerFake()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(presenter.isUpdatePhotosCalled)
    }
    
    func testShowingProgressHUD() {
        // given
        let presenter = ImagesListPresenterStub()
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.changeLike(at: 0) { _ in }
        
        // then
        XCTAssertTrue(viewController.isShowedProgressHUD)
    }
    
    func testChangeLike() {
        // given
        let service = ImagesListServiceStub()
        var isLike = false
        
        // when
        service.changeLike(photoId: "0", isLiked: isLike) { result in
            switch result {
            case .success(let photo):
                isLike = photo.isLiked
            case .failure(_):
                XCTFail()
            }
        }
        
        // then
        XCTAssertTrue(isLike)
    }
    
    func testViewDidLoadNotification() {
        let viewController = ImagesListViewControllerSpy()
        let service = ImagesListServiceStub()
        service.clearBeforeLogout()
        let presenter = ImagesListPresenter(view: viewController, imagesListService: service)
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledUpdateTable)
    }
    
    func testUpdatingPresenterPhotosCount() {
        let service = ImagesListServiceStub()
        service.clearBeforeLogout()
        let view = ImagesListViewControllerFake()
        let presenter = ImagesListPresenter(imagesListService: service)
        presenter.view = view
        view.presenter = presenter
        
        presenter.viewDidLoad()
        let count = presenter.getPhotosCount()
        
        XCTAssertEqual(count, 2)
    }
    
    func testShouldGetNextPage() {
        let service = ImagesListServiceStub()
        service.clearBeforeLogout()
        let view = ImagesListViewControllerFake()
        let presenter = ImagesListPresenter(imagesListService: service)
        presenter.view = view
        view.presenter = presenter
        
        presenter.viewDidLoad()
        
        let startCount = presenter.getPhotosCount()
        presenter.shouldGetNextPage(for: 1)
        let newCount = presenter.getPhotosCount()
        
        XCTAssertEqual(startCount + 1, newCount)
    }
    
}
