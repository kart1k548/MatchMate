import Foundation

protocol ProfileServiceProtocol {
    func fetchProfiles(url: String, completion: @escaping (Result<ProfileData, ProfileServiceError>)->Void)
}
