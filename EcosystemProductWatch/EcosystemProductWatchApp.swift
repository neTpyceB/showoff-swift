import SwiftUI

@main
struct EcosystemControlWatchApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = EcosystemStore()

    var body: some Scene {
        WindowGroup {
            WatchEcosystemView(store: store)
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
