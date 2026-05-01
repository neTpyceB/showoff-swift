import XCTest

final class SpatialCollaborationUITests: XCTestCase {
    @MainActor
    func testBoardLoads() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["North Star"].waitForExistence(timeout: 5))
    }
}
