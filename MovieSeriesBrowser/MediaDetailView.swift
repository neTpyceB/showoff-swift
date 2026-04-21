import AVKit
import SwiftUI

struct MediaDetailView: View {
    let item: MediaItem
    @State private var player: AVPlayer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PosterImageView(url: item.posterURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)

                Text(item.kind.rawValue.capitalized)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(item.title)
                    .font(.title2.weight(.bold))

                Text(item.synopsis)
                    .font(.body)

                if let player {
                    VideoPlayer(player: player)
                        .frame(height: 220)
                        .accessibilityIdentifier("trailer-player")
                }
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            player = AVPlayer(url: item.trailerURL)
        }
    }
}
