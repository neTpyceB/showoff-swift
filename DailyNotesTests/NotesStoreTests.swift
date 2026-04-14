import XCTest
@testable import DailyNotes

@MainActor
final class NotesStoreTests: XCTestCase {
    func testCreateUpdateDeleteAndPersist() {
        let defaults = UserDefaults(suiteName: "NotesStoreTests-\(UUID().uuidString)")!
        let store = NotesStore(defaults: defaults, key: "notes")

        store.create(text: "First")
        XCTAssertEqual(store.notes.map(\.text), ["First"])

        let note = store.notes[0]
        store.update(note, text: "Updated")
        XCTAssertEqual(store.notes.map(\.text), ["Updated"])

        let restored = NotesStore(defaults: defaults, key: "notes")
        XCTAssertEqual(restored.notes, store.notes)

        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.notes.isEmpty)
    }
}
