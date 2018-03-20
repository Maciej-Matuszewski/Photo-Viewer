import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    let providers: BehaviorRelay<[PhotosProvider]>
    let currentPhotosProvider: BehaviorRelay<PhotosProvider>
    let photos: BehaviorRelay<[PhotoModel]> = BehaviorRelay(value: [])

    init(providers: [PhotosProvider]) {
        guard !providers.isEmpty else {
            fatalError("HomeViewModel can not be initialized without at least one photos provider!")
        }
        self.providers = BehaviorRelay(value: providers)
        currentPhotosProvider = BehaviorRelay(value: providers.first!)
    }
}
