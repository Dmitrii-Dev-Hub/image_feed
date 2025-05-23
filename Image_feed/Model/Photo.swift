import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    var isLiked: Bool
    
    public mutating func changeLike() {
           isLiked = !isLiked
       }
}

