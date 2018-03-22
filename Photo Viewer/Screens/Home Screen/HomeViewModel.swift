import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    let currentPhotosProvider: BehaviorRelay<PhotosProvider>
    let photos: BehaviorRelay<[PhotoModel]> = BehaviorRelay(value: [])

    init(provider: PhotosProvider) {
        currentPhotosProvider = BehaviorRelay(value: provider)
    }
}
