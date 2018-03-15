import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    let providers: BehaviorRelay<[PhotosProvider]> = BehaviorRelay(value: [PinterestProvider()])
    let currentPhotosProvider: BehaviorRelay<PinterestProvider> = BehaviorRelay(value: PinterestProvider())
    let photos: BehaviorRelay<[PhotoModel]> = BehaviorRelay(value: [])
}
