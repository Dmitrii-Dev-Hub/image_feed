import UIKit

final class ImagesListService: ImagesListServiceProtocol {
    static let shared: ImagesListServiceProtocol = ImagesListService()
    
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
//    static let shared = ImagesListService()
    
    private let tokenStorage = OAuth2TokenStorage()
    private let networkService = NetworkService()
    
    private(set) var photos: [Photo] = []
    //private let imageService = ImagesListService.shared

    
    private let dateFormatter = ISO8601DateFormatter()
    private let resultDate = DateFormatter.defaultDateFormatter
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {}
    
    func clearBeforeLogout() {
        photos = []
    }
    
    func fetchPhotosNextPage() {
        if task != nil {
            print("Repeated fetch photos request ")
            return
        }
        
        let page = (lastLoadedPage ?? 0) + 1
        guard let request = makeRequestPhoto(page: page) else {
            print("Cannot construct request")
            return
        }
        
        let task = networkService.objectTask(for: request) { [weak self] (result: (Result<[PhotoResult], Error>)) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                lastLoadedPage = page
                var photos = [Photo]()
                photoResult[..<(photoResult.count - 2)].forEach {
                    guard let photo = self.convertToPhoto(from: $0) else { return }
                    photos.append(photo)
                }
                self.photos += photos
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                print("ImagesListService error: fetchPhotosNextPage - SomeError - \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    func clearPhotos() {
           photos = []
       }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        guard
            let request = makeLikeRequest(with: "https://api.unsplash.com/photos/\(photoId)/like", httpMethod: isLiked ? "DELETE" : "POST")
        else {
            return
        }
        
        
        let task = networkService.data(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let oldPhoto = self.photos[index]
                    let newPhoto = Photo(
                        id: oldPhoto.id,
                        size: oldPhoto.size,
                        createdAt: oldPhoto.createdAt,
                        welcomeDescription: oldPhoto.welcomeDescription,
                        thumbImageURL: oldPhoto.thumbImageURL,
                        largeImageURL: oldPhoto.largeImageURL,
                        isLiked: !oldPhoto.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(.success((newPhoto)))
                } else {
                    completion(.failure(NetworkError.urlSessionError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeLikeRequest(with url: String, httpMethod: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            assertionFailure("Cannot construct url")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        
        return request
    }
    
//    private func makeRequestPhoto(page: Int) -> URLRequest? {
//        let baseURL = URL(string: Constants.defaultBaseURL)
//        
//        guard
//            let url = URL(string: "/photos?page=\(page)", relativeTo: baseURL)
//        else {
//            assertionFailure("Cannot construct url")
//            return nil
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
//        return request
//    }
    private func makeRequestPhoto(page: Int) -> URLRequest? {
        let baseURL = URL(string: Constants.defaultBaseURL)
        
        guard
            let url = URL(string: "/photos?page=\(page)&per_page=10", relativeTo: baseURL)
        else {
            assertionFailure("Cannot construct url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }

    
    private func convertToPhoto(from photoResult: PhotoResult) -> Photo? {
        
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        
        guard let date = convertDate(from: photoResult.createdAt),
              let thumbImageURL = URL(string: photoResult.urls.thumb),
              let largeImageURL = URL(string: photoResult.urls.full)
        else {
            return nil
        }
        
        let photo = Photo(
            id: photoResult.id,
            size: size,
            createdAt: date,
            welcomeDescription: photoResult.description ?? photoResult.altDescription,
            thumbImageURL: thumbImageURL,
            largeImageURL: largeImageURL,
            isLiked: photoResult.likedByUser
        )
        
        return photo
    }
    
    private func convertDate(from date: String?) -> String? {
        guard let stringDate = date,
              let date = dateFormatter.date(from: stringDate) else {
            return nil
        }
        let result = resultDate.string(from: date)
        
        return result
    }
}

