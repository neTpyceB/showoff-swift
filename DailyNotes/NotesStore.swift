import Foundation

@MainActor
final class NotesStore: ObservableObject {
    @Published private(set) var notes: [Note]

    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "notes") {
        self.defaults = defaults
        self.key = key
        self.notes = defaults.data(forKey: key).map { try! JSONDecoder().decode([Note].self, from: $0) } ?? []
    }

    func create(text: String) {
        notes.append(Note(text: text))
        save()
    }

    func update(_ note: Note, text: String) {
        notes[notes.firstIndex(of: note)!].text = text
        save()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        defaults.set(try! JSONEncoder().encode(notes), forKey: key)
    }
}
