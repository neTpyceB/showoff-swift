import XCTest

final class FitnessDashboardUITests: XCTestCase {
    @MainActor
    func testGrantPermissionAndAddWorkout() {
        let app = XCUIApplication()
        app.launch()

        if app.buttons["grant-permission"].exists {
            app.buttons["grant-permission"].tap()
        }

        let rows = app.staticTexts.matching(identifier: "workout-row-title")
        let initialCount = rows.count

        app.buttons["add-workout"].tap()
        app.buttons["save-workout"].tap()

        let countPredicate = NSPredicate(format: "count == %d", initialCount + 1)
        expectation(for: countPredicate, evaluatedWith: rows)
        waitForExpectations(timeout: 5)

        XCTAssertTrue(app.otherElements["move-trend"].exists)
    }
}
