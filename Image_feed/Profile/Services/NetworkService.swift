import Foundation

struct NetworkService: NetworkServiceProtocol {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Unexpected status code")
                    print(String(data: data, encoding: .utf8) ?? "")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("url request error - \(NetworkError.urlRequestError(error))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("url session error - \(NetworkError.urlSessionError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let resultData = try decoder.decode(T.self, from: data)
                    completion(.success(resultData))
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NetworkError.urlSessionError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
}


