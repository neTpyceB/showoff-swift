import SwiftUI

@main
struct EcosystemControlApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store: EcosystemStore

    init() {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing-reset-state") {
            UserDefaults.standard.removeObject(forKey: "ecosystem.state")
        }
        _store = StateObject(wrappedValue: EcosystemStore())
    }

    var body: some Scene {
        WindowGroup {
            EcosystemDashboardView(store: store)
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
