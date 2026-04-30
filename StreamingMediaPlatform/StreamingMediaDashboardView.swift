import AVKit
import SwiftUI

struct StreamingMediaDashboardView: View {
    @ObservedObject var store: StreamingMediaStore

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    if let session = store.state.session {
                        HStack {
                            Text("Signed In")
                            Spacer()
                            Text(session.userName)
                                .accessibilityIdentifier("session-user")
                        }
                        Button("Sign Out") {
                            store.execute(.account(.signOut))
                        }
                        .accessibilityIdentifier("sign-out")
                    } else {
                        Button("Sign In Demo") {
                            store.execute(.account(.signIn("viewer")))
                        }
                        .accessibilityIdentifier("sign-in")
                    }
                }

                if store.isSignedIn {
                    if let continuation = store.continuation, let title = store.title(for: continuation.titleID) {
                        Section("Continue Watching") {
                            Button {
                                store.execute(.playback(.start(title.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title.name)
                                    Text("\(continuation.positionSeconds / 60)m")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .accessibilityIdentifier("continue-playback")
                        }
                    }

                    Section("Recommendations") {
                        ForEach(store.recommendations) { title in
                            TitleRow(title: title, isSaved: store.state.watchlistIDs.contains(title.id)) {
                                store.execute(.list(.select(title.id)))
                            } onToggleSave: {
                                store.execute(.list(.toggleWatchlist(title.id)))
                            } onPlay: {
                                store.execute(.playback(.start(title.id)))
                            }
                        }
                        Text("Cache \(store.recommendationCacheEntries)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("recommendation-cache")
                    }

                    Section("Catalog") {
                        ForEach(store.state.titles) { title in
                            TitleRow(title: title, isSaved: store.state.watchlistIDs.contains(title.id)) {
                                store.execute(.list(.select(title.id)))
                            } onToggleSave: {
                                store.execute(.list(.toggleWatchlist(title.id)))
                            } onPlay: {
                                store.execute(.playback(.start(title.id)))
                            }
                        }
                    }

                    if let selected = store.selectedTitle {
                        Section("Player") {
                            NavigationLink("Open Player") {
                                StreamingPlayerView(store: store, title: selected)
                            }
                            .accessibilityIdentifier("open-player")

                            if let playback = store.playback, playback.titleID == selected.id {
                                HStack {
                                    Text("Now Playing")
                                    Spacer()
                                    Text("\(playback.positionSeconds / 60)m")
                                        .accessibilityIdentifier("playback-position")
                                }
                                Button(playback.isPlaying ? "Pause" : "Play") {
                                    store.execute(.playback(.togglePlayPause))
                                }
                                Button("Seek +30s") {
                                    store.execute(.playback(.seek(30)))
                                }
                                Button("Stop") {
                                    store.execute(.playback(.stop))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stream")
        }
    }
}

private struct TitleRow: View {
    let title: StreamingTitle
    let isSaved: Bool
    let onSelect: () -> Void
    let onToggleSave: () -> Void
    let onPlay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                AsyncImage(url: title.artworkURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 62, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title.name)
                        .font(.headline)
                    Text("\(title.genre.rawValue) • \(title.isSeries ? "Series" : "Movie")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .onTapGesture(perform: onSelect)
            .accessibilityIdentifier("title-\(title.id.uuidString)")

            HStack {
                Button(isSaved ? "Saved" : "Save") {
                    onToggleSave()
                }
                .accessibilityIdentifier("save-\(title.id.uuidString)")
                Button("Play") {
                    onPlay()
                }
                .accessibilityIdentifier("play-\(title.id.uuidString)")
            }
            .buttonStyle(.bordered)
        }
    }
}

private struct StreamingPlayerView: View {
    @ObservedObject var store: StreamingMediaStore
    let title: StreamingTitle
    @State private var player: AVPlayer?

    var body: some View {
        VStack(spacing: 16) {
            VideoPlayer(player: player)
                .frame(height: 240)

            if let playback = store.playback, playback.titleID == title.id {
                Text("Position \(playback.positionSeconds / 60)m")
            }
        }
        .padding()
        .navigationTitle(title.name)
        .onAppear {
            player = AVPlayer(url: title.streamURL)
            player?.play()
            if store.playback?.titleID != title.id {
                store.execute(.playback(.start(title.id)))
            }
        }
        .onDisappear {
            player?.pause()
        }
    }
}
