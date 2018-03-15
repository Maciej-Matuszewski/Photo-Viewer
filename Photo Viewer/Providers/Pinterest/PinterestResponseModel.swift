import Foundation

struct PinterestResponseModel: Codable {
    let data: [PinterestPin]
    let page: PinterestPage
}

struct PinterestPin: Codable {
    let note: String?
    let id: String
    let image: PinterestPinImages?
}

struct PinterestPage: Codable {
    let cursor: String?
    let next: String?
}

struct PinterestImage: Codable {
    let url: String?
    let width: Double?
    let height: Double?
}

struct PinterestPinImages: Codable {
    let original: PinterestImage?
}
