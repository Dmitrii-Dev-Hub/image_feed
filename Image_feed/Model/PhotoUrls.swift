import Foundation

struct PhotoUrls: Decodable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
}
