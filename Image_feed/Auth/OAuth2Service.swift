import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String?
}

final class OAuth2Service {
    
//    var isAuthorized: Bool {
//        return OAuth2TokenStorage.shared.token != nil
//    }
    
    private var task: URLSessionDataTask?
    private var lastCode: String?
    private let urlSession = URLSession.shared
    static let shared = OAuth2Service()
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: "https://unsplash.com")
        
        guard
            let url = URL(string: "/oauth/token"
                          + "?client_id=\(Constants.accessKey)"
                          + "&client_secret=\(Constants.secretKey)"
                          + "&redirect_uri=\(Constants.redirectURI)"
                          + "&code=\(code)"
                          + "&grant_type=authorization_code",
                          relativeTo: baseURL)
        else {
            print("Auth2service: Error creating the URL request.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(ServiceError.differentCodes))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("OAuth2Service - fetchOAuthToken: invalid request")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let responseBody):
                if let token = responseBody.accessToken {
                    completion(.success(token))
                } else {
                    completion(.failure(NetworkError.urlSessionError))
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}
