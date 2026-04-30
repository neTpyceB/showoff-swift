import Foundation

struct StreamingMediaCommandCenter {
    func execute(_ command: StreamingMediaCommand, on state: inout StreamingMediaState, at now: Date) {
        switch command {
        case .account(.signIn(let userName)):
            state.session = StreamingSession(userName: userName, token: "token-\(userName.lowercased())")

        case .account(.signOut):
            state.session = nil
            state.playback = nil

        case .list(.select(let titleID)):
            state.selectedTitleID = titleID

        case .list(.toggleWatchlist(let titleID)):
            if state.watchlistIDs.contains(titleID) {
                state.watchlistIDs.removeAll { $0 == titleID }
            } else {
                state.watchlistIDs.append(titleID)
            }

        case .playback(.start(let titleID)):
            state.selectedTitleID = titleID
            let startPosition = state.continuation?.titleID == titleID ? state.continuation?.positionSeconds ?? 0 : 0
            state.playback = StreamingPlayback(titleID: titleID, positionSeconds: startPosition, isPlaying: true, updatedAt: now)
            state.continuation = StreamingContinuation(titleID: titleID, positionSeconds: startPosition, updatedAt: now)

        case .playback(.togglePlayPause):
            guard var playback = state.playback else { return }
            playback.isPlaying.toggle()
            playback.updatedAt = now
            state.playback = playback

        case .playback(.seek(let deltaSeconds)):
            guard var playback = state.playback else { return }
            guard let title = state.titles.first(where: { $0.id == playback.titleID }) else { return }
            let next = min(max(playback.positionSeconds + deltaSeconds, 0), title.durationSeconds)
            playback.positionSeconds = next
            playback.updatedAt = now
            state.playback = playback
            state.continuation = StreamingContinuation(titleID: playback.titleID, positionSeconds: next, updatedAt: now)

        case .playback(.stop):
            guard let playback = state.playback else { return }
            state.continuation = StreamingContinuation(titleID: playback.titleID, positionSeconds: playback.positionSeconds, updatedAt: now)
            state.playback = nil
        }

        state.lastUpdated = now
    }

    func applyPlaybackTick(on state: inout StreamingMediaState, at now: Date, seconds: Int) {
        guard var playback = state.playback else { return }
        guard playback.isPlaying else { return }
        guard let title = state.titles.first(where: { $0.id == playback.titleID }) else { return }

        playback.positionSeconds = min(playback.positionSeconds + seconds, title.durationSeconds)
        playback.updatedAt = now
        state.playback = playback
        state.continuation = StreamingContinuation(titleID: playback.titleID, positionSeconds: playback.positionSeconds, updatedAt: now)

        if playback.positionSeconds >= title.durationSeconds {
            state.playback = nil
        }
        state.lastUpdated = now
    }

    func buildRecommendations(for state: StreamingMediaState) -> [UUID] {
        let referenceGenre = state.selectedTitle?.genre ?? state.watchlistTitles.first?.genre
        let candidateIDs = state.titles
            .filter { title in
                guard !state.watchlistIDs.contains(title.id) else { return false }
                if let referenceGenre {
                    return title.genre == referenceGenre
                }
                return true
            }
            .prefix(4)
            .map(\.id)
        return Array(candidateIDs)
    }
}
