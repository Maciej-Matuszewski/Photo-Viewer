import Foundation

class PinterestSearchPinsRequest: APIRequest {
    var method = RequestType.GET
    var path = "v1/me/search/pins/"
    var parameters = [String: String]()

    init(accessToken: String, query: String, cursor: String? = nil) {
        parameters["access_token"] = accessToken
        parameters["query"] = query
        parameters["fields"] = "image,note,id"
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
    }
}
