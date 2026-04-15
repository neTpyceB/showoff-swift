import XCTest
@testable import HabitTracker

@MainActor
final class HabitStoreTests: XCTestCase {
    func testAddToggleDeleteAndPersist() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let key = "habits"
        let store = HabitStore(defaults: defaults, key: key)

        store.add("Walk")
        XCTAssertEqual(store.habits.map(\.name), ["Walk"])
        XCTAssertEqual(store.completedToday, 0)

        store.toggle(id: store.habits[0].id)
        XCTAssertEqual(store.completedToday, 1)

        let restored = HabitStore(defaults: defaults, key: key)
        XCTAssertEqual(restored.habits, store.habits)

        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.habits.isEmpty)
    }
}
