import SwiftUI

@main
struct EcosystemProductVisionApp: App {
    @StateObject private var store = EcosystemStore()

    var body: some Scene {
        WindowGroup {
            EcosystemVisionView(store: store)
                .task { store.startRealtimeUpdates() }
        }
        .windowStyle(.volumetric)
    }
}
