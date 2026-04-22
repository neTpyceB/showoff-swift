import SwiftUI

@main
struct FitnessDashboardApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = FitnessStore()

    var body: some Scene {
        WindowGroup {
            FitnessDashboardView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.refresh()
                store.startBackgroundUpdates()
            } else {
                store.stopBackgroundUpdates()
            }
        }
    }
}
