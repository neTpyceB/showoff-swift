import SwiftUI

struct AddWorkoutView: View {
    let save: (WorkoutType, Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var type: WorkoutType = .run
    @State private var durationMinutes = 30

    var body: some View {
        NavigationStack {
            Form {
                Picker("Workout", selection: $type) {
                    ForEach(WorkoutType.allCases) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                .accessibilityIdentifier("workout-type")

                Stepper(value: $durationMinutes, in: 5 ... 180, step: 5) {
                    Text("\(durationMinutes) min")
                        .accessibilityIdentifier("workout-duration")
                }
            }
            .navigationTitle("New Workout")
            .toolbar {
                Button("Save") {
                    save(type, durationMinutes)
                    dismiss()
                }
                .accessibilityIdentifier("save-workout")
            }
        }
    }
}
