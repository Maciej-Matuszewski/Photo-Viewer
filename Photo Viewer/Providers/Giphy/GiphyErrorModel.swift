import Foundation

struct GiphyErrorModel {
    let message: String
    let code: Int
}

extension GiphyErrorModel: ErrorModel {
    var statusCode: Int {
        return code
    }
}

