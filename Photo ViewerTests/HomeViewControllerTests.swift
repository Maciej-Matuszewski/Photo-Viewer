import XCTest
@testable import Photo_Viewer

class HomeViewControllerTests: XCTestCase {
    func testHomeViewModelProviderAssign() {
        let viewModel = HomeViewModel(provider: FakePhotoProvider())
        XCTAssert(viewModel.currentPhotosProvider.value is FakePhotoProvider)
    }
}

