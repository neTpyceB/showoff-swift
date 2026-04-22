import SwiftUI
import Charts

struct FitnessDashboardView: View {
    @ObservedObject var store: FitnessStore
    @State private var isAddingWorkout = false
    private let reminders = FitnessReminderScheduler()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Fitness")
            .toolbar {
                if store.permissionState == .granted {
                    Button("Reminder") {
                        Task {
                            await reminders.scheduleDaily()
                        }
                    }
                    .accessibilityIdentifier("schedule-reminder")

                    Button {
                        isAddingWorkout = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("add-workout")
                }
            }
            .sheet(isPresented: $isAddingWorkout) {
                AddWorkoutView { type, durationMinutes in
                    store.addWorkout(type: type, durationMinutes: durationMinutes)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch store.permissionState {
        case .unknown:
            permissionView(message: "Allow activity data to start the dashboard.")
        case .denied:
            permissionView(message: "Activity data access is off.")
        case .granted:
            List {
                Section("Activity Summary") {
                    summaryRow(
                        title: "Move",
                        value: store.summary.move,
                        goal: store.summary.moveGoal,
                        unit: "kcal",
                        identifier: "summary-move"
                    )
                    summaryRow(
                        title: "Exercise",
                        value: store.summary.exercise,
                        goal: store.summary.exerciseGoal,
                        unit: "min",
                        identifier: "summary-exercise"
                    )
                    summaryRow(
                        title: "Stand",
                        value: store.summary.stand,
                        goal: store.summary.standGoal,
                        unit: "hrs",
                        identifier: "summary-stand"
                    )
                }

                Section("Move Trend") {
                    Chart(store.trends) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Move", point.move)
                        )
                    }
                    .frame(height: 180)
                    .accessibilityIdentifier("move-trend")
                }

                Section("Workouts") {
                    ForEach(store.workouts) { workout in
                        HStack {
                            Label(workout.type.title, systemImage: workout.type.symbolName)
                                .accessibilityIdentifier("workout-row-title")
                            Spacer()
                            Text("\(workout.durationMinutes) min")
                        }
                    }
                    .onDelete(perform: store.deleteWorkouts)
                }
            }
        }
    }

    private func permissionView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .multilineTextAlignment(.center)

            Button("Allow Access") {
                store.grantPermission()
            }
            .accessibilityIdentifier("grant-permission")

            if store.permissionState == .unknown {
                Button("Not Now") {
                    store.denyPermission()
                }
                .accessibilityIdentifier("deny-permission")
            }
        }
        .padding()
    }

    private func summaryRow(title: String, value: Int, goal: Int, unit: String, identifier: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)/\(goal) \(unit)")
                    .accessibilityIdentifier(identifier)
            }
            ProgressView(value: Double(value), total: Double(goal))
        }
    }
}
