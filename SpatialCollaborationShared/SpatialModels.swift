import Foundation

struct WorkspaceBoard: Identifiable, Equatable {
    let id: UUID
    var title: String
    var cards: [WorkspaceCard]

    var activeCards: [WorkspaceCard] {
        cards.sorted { $0.updatedAt > $1.updatedAt }
    }
}

struct WorkspaceCard: Identifiable, Equatable {
    enum Kind: String, CaseIterable {
        case note = "Note"
        case media = "Media"
        case data = "Data"
    }

    let id: UUID
    var title: String
    var body: String
    var kind: Kind
    var position: SpatialPosition
    var updatedAt: Date

    var searchKey: String {
        "\(title) \(body) \(kind.rawValue)".lowercased()
    }
}

struct SpatialPosition: Equatable {
    var x: Double
    var y: Double
    var z: Double
}
