import XCTest

final class DailyNotesUITests: XCTestCase {
    @MainActor
    func testCreateEditDeleteNote() {
        let app = XCUIApplication()
        app.launch()

        let first = "First \(UUID().uuidString)"
        let second = "\(first) updated"

        app.buttons["add-note"].tap()
        app.textFields["note-text"].tap()
        app.textFields["note-text"].typeText(first)
        app.buttons["save-note"].tap()
        XCTAssertTrue(app.buttons[first].waitForExistence(timeout: 2))

        app.buttons[first].tap()
        app.textFields["note-text"].coordinate(withNormalizedOffset: CGVector(dx: 0.98, dy: 0.5)).tap()
        app.textFields["note-text"].typeText(" updated")
        app.buttons["save-note"].tap()
        XCTAssertTrue(app.buttons[second].waitForExistence(timeout: 2))

        app.buttons[second].swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.buttons[second].waitForExistence(timeout: 1))
    }
}
