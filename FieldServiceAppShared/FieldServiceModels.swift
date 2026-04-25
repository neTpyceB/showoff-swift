import Foundation

enum FieldJobPriority: String, CaseIterable, Codable, Identifiable, Sendable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }
}

enum FieldJobStatus: String, CaseIterable, Codable, Identifiable, Sendable {
    case open = "Open"
    case inProgress = "In Progress"
    case completed = "Completed"

    var id: String { rawValue }
}

struct FieldJob: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var title: String
    var location: String
    var note: String
    var priority: FieldJobPriority
    var status: FieldJobStatus
    var version: Int
    var updatedAt: Date
}

struct FieldMutation: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let job: FieldJob
    let baseVersion: Int
    let recordedAt: Date
}

enum FieldCommand: Sendable {
    case createJob(title: String, location: String, note: String, priority: FieldJobPriority)
    case updateStatus(jobID: UUID, status: FieldJobStatus)
    case updateNote(jobID: UUID, note: String)
}

extension FieldJob {
    static func seedData(now: Date = Date()) -> [FieldJob] {
        [
            FieldJob(
                id: UUID(),
                title: "Inspect HVAC Unit",
                location: "Plant 3",
                note: "Check pressure and filter wear.",
                priority: .high,
                status: .open,
                version: 1,
                updatedAt: now
            ),
            FieldJob(
                id: UUID(),
                title: "Deliver Parts",
                location: "Warehouse B",
                note: "Seal kits and belts.",
                priority: .medium,
                status: .inProgress,
                version: 1,
                updatedAt: now.addingTimeInterval(-60)
            ),
            FieldJob(
                id: UUID(),
                title: "Safety Walkthrough",
                location: "Site North",
                note: "Record checklist and photos.",
                priority: .low,
                status: .completed,
                version: 1,
                updatedAt: now.addingTimeInterval(-120)
            )
        ]
    }
}
