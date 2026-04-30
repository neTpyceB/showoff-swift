import Foundation

struct StreamingMediaState: Codable, Equatable, Sendable {
    var session: StreamingSession?
    var titles: [StreamingTitle]
    var selectedTitleID: UUID?
    var watchlistIDs: [UUID]
    var recommendationIDs: [UUID]
    var playback: StreamingPlayback?
    var continuation: StreamingContinuation?
    var lastUpdated: Date

    static func initial(now: Date = Date()) -> StreamingMediaState {
        let titles = StreamingTitle.seedCatalog()
        return StreamingMediaState(
            session: nil,
            titles: titles,
            selectedTitleID: titles.first?.id,
            watchlistIDs: [],
            recommendationIDs: [],
            playback: nil,
            continuation: nil,
            lastUpdated: now
        )
    }
}

extension StreamingMediaState {
    var selectedTitle: StreamingTitle? {
        guard let selectedTitleID else { return nil }
        return titles.first { $0.id == selectedTitleID }
    }

    var watchlistTitles: [StreamingTitle] {
        titles.filter { watchlistIDs.contains($0.id) }
    }

    var recommendedTitles: [StreamingTitle] {
        titles.filter { recommendationIDs.contains($0.id) }
    }
}

private extension StreamingTitle {
    static func seedCatalog() -> [StreamingTitle] {
        [
            StreamingTitle(
                id: UUID(),
                name: "City Pursuit",
                isSeries: false,
                genre: .action,
                durationSeconds: 7_200,
                artworkURL: URL(string: "https://picsum.photos/seed/citypursuit/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
            ),
            StreamingTitle(
                id: UUID(),
                name: "Orbit Nine",
                isSeries: true,
                genre: .sciFi,
                durationSeconds: 3_000,
                artworkURL: URL(string: "https://picsum.photos/seed/orbitnine/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
            ),
            StreamingTitle(
                id: UUID(),
                name: "Harbor Light",
                isSeries: false,
                genre: .drama,
                durationSeconds: 6_600,
                artworkURL: URL(string: "https://picsum.photos/seed/harborlight/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
            ),
            StreamingTitle(
                id: UUID(),
                name: "Wild Ice",
                isSeries: false,
                genre: .documentary,
                durationSeconds: 5_400,
                artworkURL: URL(string: "https://picsum.photos/seed/wildice/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!
            ),
            StreamingTitle(
                id: UUID(),
                name: "Pixel Squad",
                isSeries: true,
                genre: .family,
                durationSeconds: 1_800,
                artworkURL: URL(string: "https://picsum.photos/seed/pixelsquad/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!
            ),
            StreamingTitle(
                id: UUID(),
                name: "Iron Mile",
                isSeries: false,
                genre: .action,
                durationSeconds: 6_300,
                artworkURL: URL(string: "https://picsum.photos/seed/ironmile/800/1200")!,
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")!
            )
        ]
    }
}
