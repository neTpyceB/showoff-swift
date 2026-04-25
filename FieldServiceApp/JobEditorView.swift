import SwiftUI

struct JobEditorView: View {
    let save: (String, String, String, FieldJobPriority) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title = "New Visit"
    @State private var location = "Site A"
    @State private var note = ""
    @State private var priority: FieldJobPriority = .medium

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                    .accessibilityIdentifier("job-title")

                TextField("Location", text: $location)
                    .accessibilityIdentifier("job-location")

                TextField("Note", text: $note)
                    .accessibilityIdentifier("job-note")

                Picker("Priority", selection: $priority) {
                    ForEach(FieldJobPriority.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .accessibilityIdentifier("job-priority")
            }
            .navigationTitle("New Job")
            .toolbar {
                Button("Save") {
                    save(title, location, note, priority)
                    dismiss()
                }
                .accessibilityIdentifier("save-job")
            }
        }
    }
}
