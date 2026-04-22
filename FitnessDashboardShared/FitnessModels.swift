import Foundation

enum WorkoutType: String, CaseIterable, Codable, Identifiable, Sendable {
    case run
    case cycle
    case strength
    case yoga

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var symbolName: String {
        switch self {
        case .run:
            "figure.run"
        case .cycle:
            "figure.outdoor.cycle"
        case .strength:
            "dumbbell"
        case .yoga:
            "figure.mind.and.body"
        }
    }

    var caloriesPerMinute: Int {
        switch self {
        case .run:
            12
        case .cycle:
            10
        case .strength:
            8
        case .yoga:
            5
        }
    }
}

struct Workout: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let type: WorkoutType
    let durationMinutes: Int
    let calories: Int
    let date: Date
}

struct ActivitySummary: Codable, Equatable, Sendable {
    var moveGoal: Int
    var move: Int
    var exerciseGoal: Int
    var exercise: Int
    var standGoal: Int
    var stand: Int
}

struct TrendPoint: Identifiable, Codable, Equatable, Sendable {
    let date: Date
    let move: Double

    var id: Date { date }
}

enum PermissionState: String, Codable, Sendable {
    case unknown
    case granted
    case denied
}
