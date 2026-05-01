import SwiftUI

struct WorkspaceBoardView: View {
    @ObservedObject var viewModel: SpatialWorkspaceViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.cards, selection: $viewModel.selectedCardID) { card in
                NavigationLink {
                    CardDetailView(card: card, viewModel: viewModel)
                        .onAppear {
                            viewModel.select(card)
                        }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.title)
                            .font(.headline)
                        Text(card.kind.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .tag(card.id)
            }
            .accessibilityIdentifier("card-list")
            .navigationTitle(viewModel.board.title)
            .searchable(text: $viewModel.searchText)
            .toolbar {
                Menu {
                    ForEach(WorkspaceCard.Kind.allCases, id: \.self) { kind in
                        Button(kind.rawValue) {
                            viewModel.createCard(kind: kind)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityIdentifier("add-card")
            }
        }
    }
}
