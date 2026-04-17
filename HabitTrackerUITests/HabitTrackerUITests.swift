import XCTest

final class HabitTrackerUITests: XCTestCase {
    @MainActor
    func testCreateCompleteDeleteHabit() {
        let app = XCUIApplication()
        app.launch()

        let name = "Walk \(UUID().uuidString)"
        app.buttons["add-habit"].tap()
        app.textFields["habit-name"].tap()
        app.textFields["habit-name"].typeText(name)
        app.buttons["save-habit"].tap()

        let habit = app.buttons["habit-\(name)"]
        XCTAssertTrue(habit.waitForExistence(timeout: 2))
        habit.tap()
        XCTAssertTrue(app.progressIndicators["habit-progress"].exists)

        habit.swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertFalse(habit.waitForExistence(timeout: 1))
    }
}
