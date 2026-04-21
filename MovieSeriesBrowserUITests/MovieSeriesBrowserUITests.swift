import XCTest

final class MovieSeriesBrowserUITests: XCTestCase {
    @MainActor
    func testSearchAndOpenMediaDetail() {
        let app = XCUIApplication()
        app.launch()

        let signalCard = app.buttons["media-Signal"]
        XCTAssertTrue(signalCard.waitForExistence(timeout: 5))

        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 2))
        search.tap()
        search.typeText("signal")

        signalCard.tap()
        XCTAssertTrue(app.otherElements["trailer-player"].waitForExistence(timeout: 5))
    }
}
