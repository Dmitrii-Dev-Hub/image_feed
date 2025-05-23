import Foundation

final class ProfileImageService: ProfileImageServiceProtocol {
    
    static let shared: ProfileImageServiceProtocol = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private let tokenStorage = OAuth2TokenStorage()
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    private var task: URLSessionTask?
    private var username: String?
    
    private init() {}
    
    private func makeRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("cannot construct url for fetching image")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func clearBeforeLogout() {
           avatarURL = nil
       }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        if self.username == username {
            completion(.failure(NetworkError.urlSessionError))
            print("ProfileImageService error: fetchProfileImageURL - repeatedRequest")
            return
        }
        
        self.username = username
        task?.cancel()
        
        guard let request = makeRequest(username: username) else {
            completion(.failure(NetworkError.urlSessionError))
            print("ProfileImageService Error: fetchProfileImageURL - invalidImageRequest")
            return
        }
        
        let task = networkService.objectTask(for: request) { [weak self] (result:(Result<UserResult, Error>)) in
            assert(Thread.isMainThread)
            
            guard let self = self else { return }
            
            switch result{
            case .success(let userResult):
                guard let avatarURL = userResult.profileImage.large else {
                    completion(.failure(ServiceError.decodeError))
                    print("Error: fetchProfileImageURL - FetchingImageError - imageIsNil")
                    return
                }
                
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
                print("Error: fetchProfileImageURL - NetworkError - \(error)")
            }
            self.task = nil
            self.username = nil
        }
        
        self.task = task
        task.resume()
    }
}
