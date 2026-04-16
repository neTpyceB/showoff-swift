import XCTest

final class WeatherCompanionUITests: XCTestCase {
    @MainActor
    func testAddFavoritePlace() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["current-temperature"].waitForExistence(timeout: 10))

        app.textFields["place-query"].tap()
        app.textFields["place-query"].typeText("Paris")
        app.buttons["add-place"].tap()

        let paris = app.staticTexts.matching(identifier: "current-place").matching(NSPredicate(format: "label == %@", "Paris")).firstMatch
        XCTAssertTrue(paris.waitForExistence(timeout: 10))
    }
}
