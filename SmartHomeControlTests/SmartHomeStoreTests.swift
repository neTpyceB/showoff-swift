import XCTest
@testable import SmartHomeControl

@MainActor
final class SmartHomeStoreTests: XCTestCase {
    func testActivateAwaySceneTurnsLightsOffAndCamerasOn() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let sync = SmartHomeSync(defaults: defaults, key: "smarthome.tests.scene")
        let store = SmartHomeStore(sync: sync)

        store.execute(.activateScene(.away))

        XCTAssertEqual(store.lightsOnCount, 0)
        XCTAssertEqual(
            store.state.devices.filter { $0.kind == .camera && $0.isOn }.count,
            store.state.devices.filter { $0.kind == .camera }.count
        )
    }

    func testStatePersistenceRoundTrip() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let key = "smarthome.tests.persistence"
        let sync = SmartHomeSync(defaults: defaults, key: key)
        let store = SmartHomeStore(sync: sync)
        let lightID = store.state.devices.first { $0.kind == .light }!.id

        store.execute(.setBrightness(lightID, 90))

        let restored = SmartHomeStore(sync: SmartHomeSync(defaults: defaults, key: key))
        let restoredLight = restored.state.devices.first { $0.id == lightID }!
        XCTAssertEqual(restoredLight.brightness, 90)
    }
}
