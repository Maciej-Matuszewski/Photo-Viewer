import Foundation
import RxSwift
import RxCocoa
import SafariServices
import KeychainAccess

class PinterestProvider {
    static fileprivate var clientId: String {
        //TO-DO: Add ClientId into Cocoapods-Keys
        return <#T##clientId: String#>

    }

    static fileprivate var redirectUri: String {
        return "pdk\(clientId)://"
    }

    static public func handle(_ url: URL) -> Bool {
        let stringURL = url.absoluteString
        let urlComponents = stringURL.split(separator: "?")

        guard stringURL.hasPrefix(redirectUri),
            urlComponents.count > 1,
            let accessToken = (urlComponents[1].split(separator: "&")
                .map{ component -> (String, String) in
                    let keyValue = component.split(separator: "=")
                    return (String(keyValue[0]), String(keyValue[1]))
                }.first { (key, value) -> Bool in
                    return key == "access_token"
                }?.1)
        else { return false }

        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
        keychain["PinterestProviderToken"] = accessToken
        //TO-DO: Change Notification name
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "AuthorizationStateHasBeenChangedNotification")))
        return true
    }

    fileprivate var accessToken: String? {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
        return (try? keychain.getString("PinterestProviderToken")) ?? nil
    }

    fileprivate lazy var apiClient: APIClient = {
        return APIClient(baseURL: baseURL)
    }()

    fileprivate var cursor: String?
}

extension PinterestProvider: PhotosProvider {

    var hasMore: Bool {
        return cursor != nil
    }

    var serviceName: String {
        return "Pinterest"
    }

    var baseURL: URL {
        return URL(string: "https://api.pinterest.com/")!
    }

    var isAuthorized: Bool {
        return accessToken != nil
    }

    var emptyStateInfoText: String {
        get {
            return "Ops... There is nothing here :(\n\nPlease go to Pinterest website or app to add some pins to your board.".localized
        }
    }

    func authorize(parentController: UIViewController) {
        guard var components = URLComponents(url: baseURL.appendingPathComponent("oauth"), resolvingAgainstBaseURL: false) else { return }

        let parameters = [
            "client_id": PinterestProvider.clientId,
            "response_type": "token",
            "scope": "read_public, read_private",
            "redirect_uri": PinterestProvider.redirectUri
        ]

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else { return }

        let safariViewController = SFSafariViewController(url: url)
        parentController.present(safariViewController, animated: true, completion: nil)
    }

    func getPhotos(searchPhrase: String? = nil, cursor: String? = nil) -> Observable<[PhotoModel]> {
        guard let accessToken = accessToken else { return Observable.just([]) }
        let response: Observable<PinterestResponseModel> = apiClient.send(apiRequest: PinterestPinsRequest(accessToken: accessToken, cursor: cursor))
        return response
            .do(onNext: { [weak self] response in
                self?.cursor = response.page.cursor
            })
            .map { $0.data }
            .map { pins -> [PhotoModel] in
                pins.map { pin -> PhotoModel in
                    return PhotoModel(title: pin.note ?? "", imageURL: pin.image?.original?.url ?? "")
                }
            }
    }

    func getPhotos(searchPhrase: String?) -> Observable<[PhotoModel]> {
        return getPhotos(searchPhrase: searchPhrase, cursor: nil)
    }

    func getNextPage() -> Observable<[PhotoModel]> {
        guard let cursor = cursor else { return Observable.just([]) }
        return getPhotos(cursor: cursor)
    }
}
