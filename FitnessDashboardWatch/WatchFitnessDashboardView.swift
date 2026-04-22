import SwiftUI
import Charts

struct WatchFitnessDashboardView: View {
    @ObservedObject var store: FitnessStore

    var body: some View {
        List {
            if store.permissionState != .granted {
                Section {
                    Button("Allow Access") {
                        store.grantPermission()
                    }
                    .accessibilityIdentifier("watch-grant-permission")
                }
            } else {
                Section("Summary") {
                    Text("Move \(store.summary.move)/\(store.summary.moveGoal)")
                    Text("Exercise \(store.summary.exercise)/\(store.summary.exerciseGoal)")
                }

                Section("Trend") {
                    Chart(store.trends) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Move", point.move)
                        )
                    }
                    .frame(height: 100)
                }
            }

            Section {
                workoutButton(for: .run, durationMinutes: 20)
                workoutButton(for: .cycle, durationMinutes: 20)
                workoutButton(for: .strength, durationMinutes: 15)
            }
        }
        .navigationTitle("Fitness")
    }

    private func workoutButton(for type: WorkoutType, durationMinutes: Int) -> some View {
        Button {
            if store.permissionState != .granted {
                store.grantPermission()
            }
            store.addWorkout(type: type, durationMinutes: durationMinutes)
        } label: {
            Label(type.title, systemImage: type.symbolName)
        }
        .accessibilityIdentifier("watch-log-\(type.rawValue)")
    }
}
