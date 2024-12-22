import Foundation

struct ProfileData: Decodable {
    let results: [Profile]
}

struct Profile: Decodable {
    let email: String
    let name: Name
    let location: Location
    let picture: Picture
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    let street: Street
    let state: String
    struct Street: Decodable {
        let number: Int
        let name: String
    }
}

struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
