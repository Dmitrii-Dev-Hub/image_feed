import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description, altDescription: String?
    let urls: PhotoUrls
    let likes: Int
    let likedByUser: Bool
}

