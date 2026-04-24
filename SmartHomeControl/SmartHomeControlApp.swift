import SwiftUI

@main
struct SmartHomeControlApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = SmartHomeStore()

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
