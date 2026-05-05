import SwiftUI

@main
struct StreamingMediaPlatformApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store: StreamingMediaStore

    init() {
        _store = StateObject(wrappedValue: Self.makeStore())
    }

    var body: some Scene {
        WindowGroup {
            StreamingMediaDashboardView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startPlaybackTicks()
            } else {
                store.stopPlaybackTicks()
            }
        }
    }

    private static func makeStore() -> StreamingMediaStore {
        let args = ProcessInfo.processInfo.arguments
        guard args.contains("-ui-testing-reset-state") else {
            return StreamingMediaStore()
        }

        UserDefaults.standard.removeObject(forKey: "streaming.state")
        return StreamingMediaStore()
    }
}
