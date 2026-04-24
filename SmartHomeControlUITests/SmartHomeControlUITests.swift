import XCTest

final class SmartHomeControlUITests: XCTestCase {
    @MainActor
    func testActivateAwayScene() {
        let app = XCUIApplication()
        app.launch()

        let cameras = app.staticTexts["cameras-active-count"]
        XCTAssertTrue(cameras.waitForExistence(timeout: 5))

        app.buttons["scene-movie"].tap()
        XCTAssertEqual(cameras.label, "0")

        XCTAssertTrue(app.staticTexts["lights-on-count"].exists)
    }
}
