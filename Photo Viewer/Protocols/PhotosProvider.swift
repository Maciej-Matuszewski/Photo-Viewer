import Foundation
import RxSwift

protocol PhotosProvider {

    var serviceName: String { get }

    var baseURL: URL { get }

    var isAuthorized: Bool { get }

    func authorize(parentController: UIViewController)

    func getPhotos(page: Int?, searchPhrase: String?) -> Observable<[PhotoModel]>
}
