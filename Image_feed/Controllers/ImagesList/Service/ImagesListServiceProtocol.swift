import Foundation

public protocol ImagesListServiceProtocol {
    static var didChangeNotification: Notification.Name { get }
    static var shared: ImagesListServiceProtocol { get }
    
    var photos: [Photo] { get }
    
    func clearBeforeLogout()
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void)
    func fetchPhotosNextPage()
}
