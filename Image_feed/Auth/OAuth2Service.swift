import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String?
}

final class OAuth2Service {
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
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("OAuth2Service - fetchOAuthToken: invalid request")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let token = try decoder.decode(
                        OAuthTokenResponseBody.self, from: data)
                    guard let token = token.accessToken else {
                        completion(.failure(
                            NetworkError.urlSessionError))
                        return
                    }
                    completion(.success(token))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
