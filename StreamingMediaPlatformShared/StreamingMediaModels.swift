import Foundation

enum StreamingGenre: String, CaseIterable, Codable, Identifiable, Sendable {
    case action
    case drama
    case documentary
    case sciFi = "Sci-Fi"
    case family

    var id: String { rawValue }
}

struct StreamingTitle: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let name: String
    let isSeries: Bool
    let genre: StreamingGenre
    let durationSeconds: Int
    let artworkURL: URL
    let streamURL: URL
}

struct StreamingSession: Codable, Equatable, Sendable {
    var userName: String
    var token: String
}

struct StreamingPlayback: Codable, Equatable, Sendable {
    var titleID: UUID
    var positionSeconds: Int
    var isPlaying: Bool
    var updatedAt: Date
}

struct StreamingContinuation: Codable, Equatable, Sendable {
    var titleID: UUID
    var positionSeconds: Int
    var updatedAt: Date
}

enum StreamingAccountCommand: Sendable {
    case signIn(String)
    case signOut
}

enum StreamingPlaybackCommand: Sendable {
    case start(UUID)
    case togglePlayPause
    case seek(Int)
    case stop
}

enum StreamingListCommand: Sendable {
    case toggleWatchlist(UUID)
    case select(UUID)
}

enum StreamingMediaCommand: Sendable {
    case account(StreamingAccountCommand)
    case playback(StreamingPlaybackCommand)
    case list(StreamingListCommand)
}
