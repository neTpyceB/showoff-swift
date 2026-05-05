import XCTest

final class WeatherCompanionUITests: XCTestCase {
    @MainActor
    func testAddFavoritePlace() {
        let app = XCUIApplication()
        app.launchEnvironment["WEATHER_UI_TEST_PLACE_QUERY"] = "Paris"
        app.launch()

        XCTAssertTrue(app.staticTexts["current-temperature"].waitForExistence(timeout: 10))

        app.buttons["add-place"].tap()

        XCTAssertTrue(app.staticTexts["current-place"].waitForExistence(timeout: 30))
    }

}
