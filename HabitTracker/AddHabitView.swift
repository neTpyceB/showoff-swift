import SwiftUI

struct AddHabitView: View {
    let save: (String) -> Void
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit", text: $name)
                    .accessibilityIdentifier("habit-name")
            }
            .navigationTitle("New Habit")
            .toolbar {
                Button("Save") {
                    save(name)
                }
                .accessibilityIdentifier("save-habit")
            }
        }
    }
}
