import Foundation

enum ServiceError: Error {
    case codeError
    case invalidRequest
    case differentCodes
    case decodeError
}
