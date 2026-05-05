import XCTest

final class EcosystemControlUITests: XCTestCase {
    @MainActor
    func testActivateMovieScene() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-reset-state"]
        app.launch()

        let cameras = app.staticTexts["cameras-active-count"]
        XCTAssertTrue(cameras.waitForExistence(timeout: 5))

        app.buttons["scene-movie"].tap()
        XCTAssertTrue(waitForLabel("0", on: cameras))

        XCTAssertTrue(app.staticTexts["lights-on-count"].exists)
    }

    private func waitForLabel(_ label: String, on element: XCUIElement) -> Bool {
        let predicate = NSPredicate(format: "label == %@", label)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter().wait(for: [expectation], timeout: 5) == .completed
    }
}
