import XCTest

final class StreamingMediaPlatformUITests: XCTestCase {
    @MainActor
    func testSignInFlow() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-reset-state"]
        app.launch()

        let signIn = app.buttons["sign-in"]
        XCTAssertTrue(signIn.waitForExistence(timeout: 5))
        signIn.tap()

        XCTAssertTrue(app.buttons["sign-out"].waitForExistence(timeout: 5))
    }
}
