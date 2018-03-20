import Foundation
import RxSwift

protocol PhotosProvider {

    var serviceName: String { get }

    var baseURL: URL { get }

    var isAuthorized: Bool { get }

    var emptyStateInfoText: String { get }

    func authorize(parentController: UIViewController)

    func getPhotos(page: Int?, searchPhrase: String?) -> Observable<[PhotoModel]>
}

extension PhotosProvider {
    var emptyStateInfoText: String {
        get {
            return "Ops... There is nothing here :(".localized
        }
    }
}

