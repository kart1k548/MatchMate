import Foundation

class ContentViewModel: ObservableObject {
    private let profileService: ProfileServiceProtocol
    
    @Published var error: String?
    
    @Published var profiles: [(Profile, Data)] = []
    
    init(profileService: ProfileServiceProtocol = ProfileService(apiRequest: APIRequest.shared)) {
        self.profileService = profileService
    }
    
    public func fetchProfiles(url: String = Constants.url) {
        profileService.fetchProfiles(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileData):
                    profileData.results.forEach { profile in
                        self?.fetchImage(with: profile)
                    }
                case .failure(let error):
                    if let error = error as ProfileServiceError? {
                        switch error {
                        case .decodingError(let error): self?.error = "Error: \(error)"
                        case .wrongUrl:
                            self?.error = "URL is wrong"
                        case .serverError(let error):
                            self?.error = "Server Error: \(error)"
                        case .unknown:
                            self?.error = "Unknown Error: \(error)"
                        }
                    }
                }
            }
        }
    }
    
    private func fetchImage(with profile: Profile) {
        guard let url = URL(string: profile.picture.medium) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
            }
            
            if let data = data {
                DispatchQueue.main.async { [weak self] in
                    self?.profiles.append((profile, data))
                }
            }
        }.resume()
    }
}
