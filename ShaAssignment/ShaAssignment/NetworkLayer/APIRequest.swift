import Foundation

final class APIRequest {
    static var shared = APIRequest()

    private init() { }
    
    func getAPIRequest<T: Decodable>(url: URL, session: URLSession, completion: @escaping (Result<T, ProfileServiceError>) -> Void) {
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                    completion(.failure(.unknown))
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    completion(.failure(.serverError("Server Error: \(response.statusCode)")))
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let responseData = try decoder.decode(T.self, from: data)
                        completion(.success(responseData))
                    } catch {
                        completion(.failure(.decodingError("Decoding Error occured")))
                    }
                } else {
                    completion(.failure(.unknown))
                }
        }.resume()
    }
}
