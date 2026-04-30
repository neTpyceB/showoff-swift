import Combine
import Foundation

@MainActor
final class StreamingMediaStore: ObservableObject {
    @Published private(set) var state: StreamingMediaState {
        didSet { sync.save(state) }
    }
    @Published private(set) var recommendationCacheEntries: Int = 0

    private let sync: StreamingMediaSync
    private let commandCenter = StreamingMediaCommandCenter()
    private var playbackTickTask: Task<Void, Never>?
    private var recommendationCache: [String: [UUID]] = [:]

    init(sync: StreamingMediaSync = StreamingMediaSync()) {
        self.sync = sync
        state = sync.load() ?? .initial()
        refreshRecommendations()
    }

    deinit {
        playbackTickTask?.cancel()
    }

    var isSignedIn: Bool { state.session != nil }
    var selectedTitle: StreamingTitle? { state.selectedTitle }
    var watchlist: [StreamingTitle] { state.watchlistTitles }
    var recommendations: [StreamingTitle] { state.recommendedTitles }
    var playback: StreamingPlayback? { state.playback }
    var continuation: StreamingContinuation? { state.continuation }

    func title(for id: UUID?) -> StreamingTitle? {
        guard let id else { return nil }
        return state.titles.first { $0.id == id }
    }

    func execute(_ command: StreamingMediaCommand) {
        var updated = state
        commandCenter.execute(command, on: &updated, at: Date())
        state = updated
        refreshRecommendations()
    }

    func startPlaybackTicks(intervalSeconds: UInt64 = 10) {
        stopPlaybackTicks()
        playbackTickTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: intervalSeconds * 1_000_000_000)
                await self?.applyPlaybackTick(seconds: Int(intervalSeconds))
            }
        }
    }

    func stopPlaybackTicks() {
        playbackTickTask?.cancel()
        playbackTickTask = nil
    }

    private func applyPlaybackTick(seconds: Int) {
        var updated = state
        commandCenter.applyPlaybackTick(on: &updated, at: Date(), seconds: seconds)
        state = updated
    }

    private func refreshRecommendations() {
        let key = recommendationCacheKey()
        if let cached = recommendationCache[key] {
            state.recommendationIDs = cached
            return
        }

        let ids = commandCenter.buildRecommendations(for: state)
        recommendationCache[key] = ids
        recommendationCacheEntries = recommendationCache.count
        state.recommendationIDs = ids
    }

    private func recommendationCacheKey() -> String {
        let selected = state.selectedTitleID?.uuidString ?? "none"
        let watchlist = state.watchlistIDs.map(\.uuidString).sorted().joined(separator: ",")
        return "\(selected)|\(watchlist)"
    }
}
