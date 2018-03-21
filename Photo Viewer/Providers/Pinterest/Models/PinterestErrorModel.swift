import Foundation

struct PinterestErrorModel: Codable {
    let status: String
    let message: String
    let code: Int
}

extension PinterestErrorModel: ErrorModel {
    var statusCode: Int {
        return code
    }
}
