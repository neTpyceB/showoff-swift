import SwiftUI

@main
struct SmartHomeControlWatchApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = SmartHomeStore()

    var body: some Scene {
        WindowGroup {
            WatchSmartHomeView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startRealtimeUpdates(intervalSeconds: 8)
            } else {
                store.stopRealtimeUpdates()
            }
        }
    }
}
