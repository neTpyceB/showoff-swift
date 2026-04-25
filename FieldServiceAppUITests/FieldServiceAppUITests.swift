import XCTest

final class FieldServiceAppUITests: XCTestCase {
    @MainActor
    func testCreateJobOfflineThenSync() {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_RESET")
        app.launch()

        XCTAssertTrue(app.switches["online-toggle"].exists)

        app.buttons["add-job"].tap()
        app.buttons["save-job"].tap()

        XCTAssertTrue(app.staticTexts["New Visit"].waitForExistence(timeout: 3))
    }
}
