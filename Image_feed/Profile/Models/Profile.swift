import Foundation

public struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    
    init(model: ProfileResult) {
        userName = model.username
        name = "\(model.firstName) \(model.lastName ?? "")"
        loginName = "@\(model.username)"
        bio = model.bio ?? ""
    }
    public init() {
        name = "test"
        userName = "test"
        loginName = "@test"
        bio = "test"
    }
}

