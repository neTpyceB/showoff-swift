import SwiftUI

@main
struct StreamingMediaPlatformWatchApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = StreamingMediaStore()

    var body: some Scene {
        WindowGroup {
            WatchStreamingMediaView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startPlaybackTicks(intervalSeconds: 15)
            } else {
                store.stopPlaybackTicks()
            }
        }
    }
}
