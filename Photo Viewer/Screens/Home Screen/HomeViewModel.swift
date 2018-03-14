import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {

    let photos: BehaviorRelay<[PhotoModel]> = BehaviorRelay(value: [])

    init() {
        //TO-DO: Replace for photos from PhotosProvider
        let tempPhotos = [
            PhotoModel(title: "Photo One", imageURL: "https://drscdn.500px.org/photo/195812625/q%3D80_m%3D2000/v2?webp=true&sig=273d9ff2106e39ccee292b2687694f9812262a7f4c245c345b8f1215e9c6217a"),
            PhotoModel(title: "Photo Two", imageURL: "https://assetcdn.500px.org/assets/static_pages/footer_bg-ef502b21d4c84130aad4a56b2873bc44.jpg")
        ]
        photos.accept(tempPhotos)
    }

}
