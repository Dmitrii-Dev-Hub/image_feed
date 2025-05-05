import Foundation
import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastToken == token {
            completion(.failure(ServiceError.differentCodes))
            print("ProfileService error: fetchProfile - repeatedRequest")
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard
            let request = makeRequest()
        else {
            print("ProfileService error: creating the URL request.")
            return
        }
        
        let task = networkService.objectTask(for: request) { [weak self] (result: (Result<ProfileResult, Error>)) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let profile = Profile(model: data)
                self.profile = profile
                profileImageService.fetchProfileImageURL(username: data.username) { _ in }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                print("ProfileService error: fetchProfile decoding - \(error)")
            }
            
            self.task = nil
            self.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest() -> URLRequest? {
        let baseURL = URL(string: Constants.defaultBaseURL)
        
        guard
            let url = URL(string: "/me", relativeTo: baseURL)
        else {
            assertionFailure("Cannot construct url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
