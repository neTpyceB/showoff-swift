import AVKit
import SwiftUI

@main
struct StreamingMediaPlatformTVApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = StreamingMediaStore()

    var body: some Scene {
        WindowGroup {
            TVStreamingMediaView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startPlaybackTicks()
            } else {
                store.stopPlaybackTicks()
            }
        }
    }
}

private struct TVStreamingMediaView: View {
    @ObservedObject var store: StreamingMediaStore
    @State private var focusedTitleID: UUID?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text(store.isSignedIn ? "Welcome \(store.state.session!.userName)" : "Signed Out")
                        .font(.title2)

                    if !store.isSignedIn {
                        Button("Sign In Demo") {
                            store.execute(.account(.signIn("viewer")))
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if store.isSignedIn {
                        Text("Recommendations")
                            .font(.title2)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: 18)], spacing: 18) {
                            ForEach(store.recommendations) { title in
                                TVTitleTile(title: title, focused: focusedTitleID == title.id)
                                    .focusable(true) { focused in
                                        if focused {
                                            focusedTitleID = title.id
                                            store.execute(.list(.select(title.id)))
                                        }
                                    }
                                    .onTapGesture {
                                        store.execute(.playback(.start(title.id)))
                                    }
                            }
                        }

                        if let selected = store.selectedTitle {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(selected.name)
                                    .font(.title2)
                                VideoPlayer(player: AVPlayer(url: selected.streamURL))
                                    .frame(height: 360)
                                    .onAppear {
                                        store.execute(.playback(.start(selected.id)))
                                    }
                                HStack {
                                    Button("Save") {
                                        store.execute(.list(.toggleWatchlist(selected.id)))
                                    }
                                    Button("Pause/Play") {
                                        store.execute(.playback(.togglePlayPause))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(36)
            }
            .navigationTitle("Streaming TV")
        }
    }
}

private struct TVTitleTile: View {
    let title: StreamingTitle
    let focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: title.artworkURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 210)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(title.name)
                .font(.headline)
            Text(title.genre.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(focused ? Color.white.opacity(0.18) : Color.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
