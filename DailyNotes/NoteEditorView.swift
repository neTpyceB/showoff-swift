import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String

    let title: String
    let onSave: (String) -> Void

    init(title: String, text: String, onSave: @escaping (String) -> Void) {
        self.title = title
        self._text = State(initialValue: text)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            TextField("Note", text: $text)
                .accessibilityIdentifier("note-text")
                .padding()
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            onSave(text)
                            dismiss()
                        }
                        .accessibilityIdentifier("save-note")
                    }
                }
        }
    }
}
