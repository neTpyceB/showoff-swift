import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var doneDays: Set<String>

    init(id: UUID = UUID(), name: String, doneDays: Set<String> = []) {
        self.id = id
        self.name = name
        self.doneDays = doneDays
    }

    var isDoneToday: Bool {
        doneDays.contains(Self.dayKey())
    }

    mutating func toggleToday() {
        let key = Self.dayKey()
        if doneDays.contains(key) {
            doneDays.remove(key)
        } else {
            doneDays.insert(key)
        }
    }

    mutating func markDoneToday() {
        doneDays.insert(Self.dayKey())
    }

    static func dayKey(_ date: Date = Date(), calendar: Calendar = .current) -> String {
        let day = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", day.year!, day.month!, day.day!)
    }
}
