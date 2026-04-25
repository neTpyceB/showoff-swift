import SwiftUI

@main
struct FieldServiceAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store: FieldServiceStore
    private let scheduler = FieldServiceBackgroundScheduler()

    init() {
        let defaults = UserDefaults.standard
        if ProcessInfo.processInfo.arguments.contains("UI_TEST_RESET") {
            defaults.removeObject(forKey: "fieldservice.jobs")
            defaults.removeObject(forKey: "fieldservice.queue")
            defaults.removeObject(forKey: "fieldservice.remote")
        }
        _store = StateObject(wrappedValue: FieldServiceStore(defaults: defaults))
    }

    var body: some Scene {
        WindowGroup {
            FieldServiceAppView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.syncNow()
                store.startBackgroundSync(intervalSeconds: scheduler.syncIntervalSeconds)
            } else {
                store.stopBackgroundSync()
            }
        }
    }
}
