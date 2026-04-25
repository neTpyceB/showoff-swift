import SwiftUI

@main
struct FieldServiceAppWatchApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = FieldServiceStore()

    var body: some Scene {
        WindowGroup {
            WatchFieldServiceAppView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.syncNow()
                store.startBackgroundSync(intervalSeconds: 15)
            } else {
                store.stopBackgroundSync()
            }
        }
    }
}
