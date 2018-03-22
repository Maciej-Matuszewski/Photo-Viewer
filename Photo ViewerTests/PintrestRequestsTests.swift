import XCTest
@testable import Photo_Viewer

class PintrestRequestsTests: XCTestCase {
    func testPinterestPinsRequestWithoutCursor() {
        let request = PinterestPinsRequest(accessToken: "AccessToken", cursor: nil)
        XCTAssertEqual(request.parameters["access_token"], "AccessToken")
        XCTAssertNil(request.parameters["cursor"])
    }

    func testPinterestPinsRequestWithCursor() {
        let request = PinterestPinsRequest(accessToken: "AccessToken", cursor: "Cursor")
        XCTAssertEqual(request.parameters["access_token"], "AccessToken")
        XCTAssertEqual(request.parameters["cursor"], "Cursor")
    }

    func testPinterestSearchPinsRequestWithCursor() {
        let request = PinterestSearchPinsRequest(accessToken: "AccessToken", query: "Query", cursor: "Cursor")
        XCTAssertEqual(request.parameters["access_token"], "AccessToken")
        XCTAssertEqual(request.parameters["cursor"], "Cursor")
        XCTAssertEqual(request.parameters["query"], "Query")
    }
}
