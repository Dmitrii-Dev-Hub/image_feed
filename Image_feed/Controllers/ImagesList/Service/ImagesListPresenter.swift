import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
        
        if !photos.isEmpty {
            view?.updateTableViewAnimated()
        }
        
        nextPage()
    }

    
    
    var photos = [Photo]()
    private let imagesListService: ImagesListServiceProtocol
    weak var view: ImagesListViewControllerProtocol?
    
    
    init(view: ImagesListViewControllerProtocol? = nil,
         imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.view = view
        self.imagesListService = imagesListService
    }
    
    func getPhotosCount() -> Int {
        print(photos.count)
         return photos.count
    }
    
    func getPhoto(at index: Int) -> Photo? {
        guard index <= photos.count - 1 else {
            return nil
        }
        return photos[index]
    }
    
    func updatePhotosAndGetCounts() -> (Int, Int) {
        let oldCount = getPhotosCount()
        photos = imagesListService.photos
        let newCount = getPhotosCount()
        return (oldCount, newCount)
    }
    
    func nextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func shouldGetNextPage(for index: Int) {
        let testMode =  ProcessInfo.processInfo.arguments.contains("testMode")
        if index == getPhotosCount() - 1 && !testMode {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        let photo = photos[index]
        
        //        UIBlockingProgressHUD.show()
        //        imagesListService.changeLike(
        //            photoId: photo.id,
        //            isLiked: photo.isLiked
        //        ) {
        //            [weak self] result in
        //
        //        }
        
        imagesListService.changeLike(photoId: photo.id, isLiked: photo.isLiked)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newPhoto):
                self.photos[index] = newPhoto
                completion(.success(newPhoto.isLiked))
            case .failure(let error):
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
