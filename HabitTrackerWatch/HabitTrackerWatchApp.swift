import SwiftUI

@main
struct HabitTrackerWatchApp: App {
    var body: some Scene {
        WindowGroup {
            HabitTrackerWatchRootView()
        }
    }
}

struct HabitTrackerWatchRootView: View {
    @StateObject private var store: HabitStore
    @StateObject private var sync: HabitSync

    init() {
        let store = HabitStore()
        _store = StateObject(wrappedValue: store)
        _sync = StateObject(wrappedValue: HabitSync(store: store))
    }

    var body: some View {
        WatchHabitListView(store: store, sync: sync)
    }
}
