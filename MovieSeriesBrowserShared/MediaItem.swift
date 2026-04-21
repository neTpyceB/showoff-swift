import Foundation

enum MediaKind: String, CaseIterable, Codable, Equatable, Sendable {
    case movie
    case series
}

struct MediaItem: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let title: String
    let kind: MediaKind
    let synopsis: String
    let posterURL: URL
    let trailerURL: URL

    init(id: UUID = UUID(), title: String, kind: MediaKind, synopsis: String, posterURL: URL, trailerURL: URL) {
        self.id = id
        self.title = title
        self.kind = kind
        self.synopsis = synopsis
        self.posterURL = posterURL
        self.trailerURL = trailerURL
    }

    var searchKey: String {
        "\(title) \(kind.rawValue)".lowercased()
    }
}
