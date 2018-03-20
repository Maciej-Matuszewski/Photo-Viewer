import Foundation

class PinterestPinsRequest: APIRequest {
    var method = RequestType.GET
    var path = "v1/me/pins/"
    var parameters = [String: String]()

    init(accessToken: String, cursor: String? = nil) {
        parameters["access_token"] = accessToken
        parameters["fields"] = "image,note,id"
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
    }
}
