import SwiftUI

@main
struct SmartHomeControlApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store: SmartHomeStore

    init() {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing-reset-state") {
            UserDefaults.standard.removeObject(forKey: "smarthome.state")
        }
        _store = StateObject(wrappedValue: SmartHomeStore())
    }

    var body: some Scene {
        WindowGroup {
            SmartHomeDashboardView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startRealtimeUpdates()
            } else {
                store.stopRealtimeUpdates()
            }
        }
    }
}
