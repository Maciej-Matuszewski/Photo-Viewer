import Foundation
import RxSwift

protocol PhotosProvider {

    var serviceName: String { get }

    var baseURL: URL { get }

    var isAuthorized: Bool { get }

    var emptyStateInfoText: String { get }

    var hasMore: Bool { get }

    var errorHandler: ErrorHandler { get }

    func authorize(parentController: UIViewController)

    func getPhotos(searchPhrase: String?) -> Observable<[PhotoModel]>

    func getNextPage() -> Observable<[PhotoModel]>
}

extension PhotosProvider {
    var emptyStateInfoText: String {
        get {
            return "Ops... There is nothing here :(".localized
        }
    }
}

