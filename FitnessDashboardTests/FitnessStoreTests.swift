import XCTest
@testable import FitnessDashboard

@MainActor
final class FitnessStoreTests: XCTestCase {
    func testPermissionStatePersists() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let workoutsKey = "fitness.workouts.tests"
        let permissionKey = "fitness.permission.tests"
        let store = FitnessStore(defaults: defaults, workoutsKey: workoutsKey, permissionKey: permissionKey)

        XCTAssertEqual(store.permissionState, .unknown)
        store.grantPermission()
        XCTAssertEqual(store.permissionState, .granted)

        let restored = FitnessStore(defaults: defaults, workoutsKey: workoutsKey, permissionKey: permissionKey)
        XCTAssertEqual(restored.permissionState, .granted)
    }

    func testAddWorkoutUpdatesSummaryAndTrends() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = FitnessStore(
            defaults: defaults,
            workoutsKey: "fitness.workouts.tests.add",
            permissionKey: "fitness.permission.tests.add"
        )

        store.grantPermission()
        store.addWorkout(type: .run, durationMinutes: 30, date: Date())

        XCTAssertEqual(store.workouts.count, 1)
        XCTAssertEqual(store.summary.exercise, 30)
        XCTAssertEqual(store.summary.move, 360)
        XCTAssertEqual(store.trends.count, 7)
        XCTAssertEqual(store.trends.last?.move, 360)
    }
}
