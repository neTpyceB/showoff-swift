import AVKit
import SwiftUI

struct TVMediaCatalogView: View {
    @StateObject var viewModel: CatalogViewModel
    @FocusState private var focusedID: UUID?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 260), spacing: 28)], spacing: 30) {
                    ForEach(viewModel.filtered) { item in
                        NavigationLink {
                            TVMediaDetailView(item: item)
                        } label: {
                            TVMediaCard(item: item)
                                .scaleEffect(focusedID == item.id ? 1.05 : 1)
                                .animation(.easeOut(duration: 0.15), value: focusedID == item.id)
                        }
                        .buttonStyle(.plain)
                        .focusable(true)
                        .focused($focusedID, equals: item.id)
                    }
                }
                .padding(40)
            }
            .navigationTitle("Catalog")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .task { viewModel.load() }
        }
    }
}

private struct TVMediaCard: View {
    let item: MediaItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: item.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.15))
            }
            .frame(height: 340)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(item.title)
                .font(.headline)
                .lineLimit(2)

            Text(item.kind.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 260, alignment: .leading)
    }
}

private struct TVMediaDetailView: View {
    let item: MediaItem
    @State private var player: AVPlayer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                AsyncImage(url: item.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 420)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(item.title)
                    .font(.largeTitle.weight(.bold))

                Text(item.synopsis)
                    .font(.title3)

                if let player {
                    VideoPlayer(player: player)
                        .frame(height: 360)
                }
            }
            .padding(40)
        }
        .navigationTitle(item.title)
        .task {
            player = AVPlayer(url: item.trailerURL)
        }
    }
}
