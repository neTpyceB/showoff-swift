import SwiftUI

struct WatchStreamingMediaView: View {
    @ObservedObject var store: StreamingMediaStore

    var body: some View {
        List {
            Section("Session") {
                if store.isSignedIn {
                    Text(store.state.session!.userName)
                    Button("Sign Out") {
                        store.execute(.account(.signOut))
                    }
                } else {
                    Button("Sign In Demo") {
                        store.execute(.account(.signIn("viewer")))
                    }
                    .accessibilityIdentifier("watch-sign-in")
                }
            }

            if store.isSignedIn {
                if let continuation = store.continuation, let title = store.title(for: continuation.titleID) {
                    Section("Continue") {
                        Button(title.name) {
                            store.execute(.playback(.start(title.id)))
                        }
                        Text("\(continuation.positionSeconds / 60)m")
                    }
                }

                Section("Watchlist") {
                    ForEach(store.watchlist.prefix(4)) { title in
                        Button(title.name) {
                            store.execute(.list(.select(title.id)))
                        }
                    }
                }

                if let selected = store.selectedTitle {
                    Section("Selected") {
                        Text(selected.name)
                        Button("Save/Unsave") {
                            store.execute(.list(.toggleWatchlist(selected.id)))
                        }
                        Button("Play/Pause") {
                            if store.playback?.titleID == selected.id {
                                store.execute(.playback(.togglePlayPause))
                            } else {
                                store.execute(.playback(.start(selected.id)))
                            }
                        }
                        .accessibilityIdentifier("watch-play-pause")
                    }
                }
            }
        }
        .navigationTitle("Companion")
    }
}
