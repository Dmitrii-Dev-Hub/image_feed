import Foundation
import Image_feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
//    func getPhoto(at index: Int) -> Image_feed.Photo? {
//        
//    }

    
    weak var view: (any Image_feed.ImagesListViewControllerProtocol)?
    var photos = [Photo]()
    
    var isViewDidLoad = false
    var isUpdatePhotosCalled = false
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhoto(at index: Int) -> Photo? {
        return nil
    }
    
    func updatePhotosAndGetCounts() -> (Int, Int) {
        isUpdatePhotosCalled = true
        return (0, 0)
    }
    
    func nextPage() {
        
    }
    
    func shouldGetNextPage(for index: Int) {
        
    }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        
    }
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
}
