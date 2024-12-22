import Foundation

enum ProfileServiceError: Error, Equatable {
    case wrongUrl
    case decodingError(String)
    case serverError(String)
    case unknown
}

class ProfileService: ProfileServiceProtocol {
    let apiRequest: APIRequest
    let session: URLSession
    
    init(apiRequest: APIRequest = APIRequest.shared, session: URLSession = URLSession.shared) {
        self.apiRequest = apiRequest
        self.session = session
    }
    
    func fetchProfiles(url: String, completion: @escaping (Result<ProfileData, ProfileServiceError>)->Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.wrongUrl))
            return
        }
        apiRequest.getAPIRequest(url: url, session: session) { result in
            completion(result)
        }
    }
}
