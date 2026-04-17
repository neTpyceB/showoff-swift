import Combine
import Foundation

@MainActor
final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] {
        didSet { save() }
    }

    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "habits") {
        self.defaults = defaults
        self.key = key
        habits = defaults.data(forKey: key).map { try! JSONDecoder().decode([Habit].self, from: $0) } ?? []
    }

    var completedToday: Int {
        habits.filter(\.isDoneToday).count
    }

    func add(_ name: String) {
        habits.append(Habit(name: name))
    }

    func delete(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func toggle(id: UUID) {
        let index = habits.firstIndex { $0.id == id }!
        habits[index].toggleToday()
    }

    func markDone(id: UUID) {
        let index = habits.firstIndex { $0.id == id }!
        habits[index].markDoneToday()
    }

    func replace(with habits: [Habit]) {
        self.habits = habits
    }

    private func save() {
        defaults.set(try! JSONEncoder().encode(habits), forKey: key)
    }
}
