import SwiftUI

struct SpatialWorkspaceView: View {
    @ObservedObject var viewModel: SpatialWorkspaceViewModel

    var body: some View {
        HStack(spacing: 28) {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.board.title)
                    .font(.largeTitle.bold())

                ForEach(WorkspaceCard.Kind.allCases, id: \.self) { kind in
                    Button {
                        viewModel.createCard(kind: kind)
                    } label: {
                        Label(kind.rawValue, systemImage: icon(for: kind))
                    }
                }

                if let card = viewModel.selectedCard {
                    Divider()
                    Text(card.title)
                        .font(.title2.bold())
                    Text(card.body)
                    Button("Delete") {
                        viewModel.deleteSelected()
                    }
                }
            }
            .frame(width: 280, alignment: .topLeading)
            .padding(28)

            ZStack {
                ForEach(viewModel.cards) { card in
                    SpatialCardView(card: card, isSelected: card.id == viewModel.selectedCardID)
                        .offset(x: card.position.x - 180, y: card.position.y - 220)
                        .scaleEffect(1 + card.position.z / 500)
                        .onTapGesture {
                            viewModel.select(card)
                        }
                }
            }
            .frame(width: 480, height: 520)
        }
        .padding(32)
    }

    private func icon(for kind: WorkspaceCard.Kind) -> String {
        switch kind {
        case .note: "note.text"
        case .media: "photo"
        case .data: "chart.bar"
        }
    }
}

private struct SpatialCardView: View {
    let card: WorkspaceCard
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(card.title)
                .font(.headline)
            Text(card.kind.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 170, height: 120, alignment: .topLeading)
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? .blue : .clear, lineWidth: 3)
        }
    }

    private var icon: String {
        switch card.kind {
        case .note: "note.text"
        case .media: "photo"
        case .data: "chart.bar"
        }
    }
}
