import SwiftUI

struct ContentView: View {
    @StateObject private var store = NotesStore()
    @State private var creating = false
    @State private var editing: Note?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.notes) { note in
                    Button(note.text) {
                        editing = note
                    }
                }
                .onDelete(perform: store.delete)
            }
            .navigationTitle("Daily Notes")
            .toolbar {
                Button("Add") {
                    creating = true
                }
                .accessibilityIdentifier("add-note")
            }
            .sheet(isPresented: $creating) {
                NoteEditorView(title: "New Note", text: "") {
                    store.create(text: $0)
                }
            }
            .sheet(item: $editing) { note in
                NoteEditorView(title: "Edit Note", text: note.text) {
                    store.update(note, text: $0)
                }
            }
        }
    }
}
