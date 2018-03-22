import Foundation
import RxSwift
import RxCocoa

import GiphyCoreSDK

class GiphyProvider {
    //TO-DO: This key should be stored using `CocoaPods-Keys`,
    //but in order not to hinder checking the project I left it unencrypted
    fileprivate let client = GPHClient(apiKey: "YL7751YRdZ7moEJoUBer49qwGt9zpTid")
    fileprivate var cursor: Int = 0
    fileprivate var total: Int = 0
    fileprivate var searchPhrase: String?
    fileprivate let _errorHandler = GiphyErrorHandler()
}

extension GiphyProvider: PhotosProvider {
    var logoImage: UIImage {
        return #imageLiteral(resourceName: "giphy")
    }

    var serviceName: String {
        return "Giphy"
    }

    var baseURL: URL {
        fatalError()
    }

    var autoAuth: Bool {
        get {
            return true
        }
    }

    var isAuthorized: Bool {
        return UserDefaults.standard.bool(forKey: "GiphyAuthStatus")
    }

    var hasMore: Bool {
        return cursor < total
    }

    var errorHandler: ErrorHandler {
        return _errorHandler
    }

    func authorize(parentController: UIViewController) {
        UserDefaults.standard.set(true, forKey: "GiphyAuthStatus")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(Notification(name: Notification.AuthorizationStateHasBeenChanged))
    }

    func getPhotos(searchPhrase: String?, cursor: Int) -> Observable<[PhotoModel]> {
        return Observable<[PhotoModel]>.create { [unowned self] observer in
            let completionHandler: (GPHListMediaResponse?, Error?) -> Void = { (response, error) in
                if let error = error as NSError? {
                    observer.onError(APIError.ResponseError(GiphyErrorModel(message: error.localizedDescription, code: error.code)))
                }

                if let response = response, let data = response.data, let pagination = response.pagination {
                    self.cursor = pagination.offset + pagination.count
                    self.total = pagination.totalCount
                    self.searchPhrase = searchPhrase
                    let photos = data.map { media -> PhotoModel in
                        return PhotoModel(title: media.title ?? "", imageURL: media.images?.original?.gifUrl ?? "")
                    }
                    observer.onNext(photos)
                } else {
                    observer.onNext([])
                }
                observer.onCompleted()
            }

            let task: Operation

            if let searchPhrase = searchPhrase,
                !searchPhrase.isEmpty {
                task = self.client.search(searchPhrase, offset: cursor, completionHandler: completionHandler)
            } else {
                task = self.client.trending(offset: cursor, completionHandler: completionHandler)
            }

            task.start()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    func getPhotos(searchPhrase: String?) -> Observable<[PhotoModel]> {
        return getPhotos(searchPhrase: searchPhrase, cursor: 0)
    }

    func getNextPage() -> Observable<[PhotoModel]> {
        return getPhotos(searchPhrase: searchPhrase, cursor: cursor)
    }
}

