import Foundation

class PinterestPinsRequest: APIRequest {
    var method = RequestType.GET
    var path = "v1/me/pins/"
    var parameters = [String: String]()

    init(accessToken: String) {
        parameters["access_token"] = accessToken
        parameters["fields"] = "image,note,id"
    }
}
