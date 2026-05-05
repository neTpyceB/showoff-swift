import XCTest

final class SmartHomeControlUITests: XCTestCase {
    @MainActor
    func testActivateMovieScene() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-reset-state"]
        app.launch()

        XCTAssertTrue(app.staticTexts["cameras-active-count"].waitForExistence(timeout: 10))

        app.buttons["scene-movie"].tap()
        XCTAssertTrue(waitForLabel("0", identifier: "cameras-active-count", in: app))

        XCTAssertTrue(app.staticTexts["lights-on-count"].exists)
    }

    @MainActor
    private func waitForLabel(_ label: String, identifier: String, in app: XCUIApplication) -> Bool {
        let deadline = Date().addingTimeInterval(10)
        while Date() < deadline {
            if app.staticTexts[identifier].label == label {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return false
    }
}
