import UIKit
import RxSwift
@testable import Photo_Viewer

class FakePhotoProvider: PhotosProvider {
    var serviceName: String {
        return "FakePhotoProvider"
    }

    var baseURL: URL {
        return URL(string: "http://fakeurl.com")!
    }

    var isAuthorized: Bool {
        return true
    }

    var hasMore: Bool {
        return false
    }

    var errorHandler: ErrorHandler {
        return FakeErrorHandler()
    }

    func authorize(parentController: UIViewController) {
        fatalError("Unsuported in tests")
    }

    func getPhotos(searchPhrase: String?) -> Observable<[PhotoModel]> {
        if !(searchPhrase?.isEmpty ?? true) {
            return Observable.just([PhotoModel(title: "searchTitle1", imageURL: "url1"), PhotoModel(title: "searchTitle2", imageURL: "url2"), PhotoModel(title: "searchTitle3", imageURL: "url3")])
        }
        return Observable.just([PhotoModel(title: "title1", imageURL: "url1"), PhotoModel(title: "title2", imageURL: "url2"), PhotoModel(title: "title3", imageURL: "url3")])
    }

    func getNextPage() -> Observable<[PhotoModel]> {
        return Observable.just([PhotoModel(title: "title5", imageURL: "url5")])
    }
}

class FakeErrorHandler: ErrorHandler {
    func handleError(code: Int) -> (message: String?, callback: (() -> ())?) {
        return (message: nil, callback: nil)
    }
}
