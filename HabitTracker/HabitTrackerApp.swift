import SwiftUI

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HabitTrackerRootView()
        }
    }
}

struct HabitTrackerRootView: View {
    @StateObject private var store: HabitStore
    @StateObject private var sync: HabitSync

    init() {
        let store = HabitStore()
        _store = StateObject(wrappedValue: store)
        _sync = StateObject(wrappedValue: HabitSync(store: store))
    }

    var body: some View {
        HabitListView(store: store, sync: sync)
    }
}
