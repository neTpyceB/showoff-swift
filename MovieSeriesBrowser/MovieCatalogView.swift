import SwiftUI

struct MovieCatalogView: View {
    @StateObject var viewModel: CatalogViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    if !viewModel.featured.isEmpty {
                        Text("Featured")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.featured) { item in
                                    NavigationLink {
                                        MediaDetailView(item: item)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 8) {
                                            PosterImageView(url: item.posterURL)
                                                .frame(width: 150, height: 220)
                                            Text(item.title)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundStyle(.primary)
                                                .lineLimit(2)
                                        }
                                        .frame(width: 150, alignment: .leading)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityIdentifier("featured-\(item.title)")
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 14) {
                        ForEach(viewModel.filtered) { item in
                            NavigationLink {
                                MediaDetailView(item: item)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    PosterImageView(url: item.posterURL)
                                        .frame(height: 220)
                                    Text(item.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("media-\(item.title)")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Browse")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .task { viewModel.load() }
        }
    }
}
