import XCTest
@testable import Photo_Viewer

class PinterestErrorHandlerTests: XCTestCase {
    func testErrorCode3() {
        let errorHandler = PinterestErrorHandler()
        let handling = errorHandler.handleError(code: 3)
        XCTAssertEqual(handling.message, "Access token is not valid!".localized)
        XCTAssertNotNil(handling.callback)
    }

    func testErrorCodeUnknown() {
        let errorHandler = PinterestErrorHandler()
        let handling = errorHandler.handleError(code: -999)
        XCTAssertEqual(handling.message, "Something went wrong".localized)
        XCTAssertNil(handling.callback)
    }
}

