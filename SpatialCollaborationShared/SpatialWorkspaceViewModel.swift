import Foundation

@MainActor
final class SpatialWorkspaceViewModel: ObservableObject {
    @Published private(set) var board = WorkspaceBoard(id: UUID(), title: "", cards: [])
    @Published var selectedCardID: UUID?
    @Published var searchText = ""

    private let store: SpatialBoardStore

    init(store: SpatialBoardStore = SpatialBoardStore()) {
        self.store = store
    }

    var cards: [WorkspaceCard] {
        guard !searchText.isEmpty else { return board.activeCards }
        let query = searchText.lowercased()
        return board.activeCards.filter { $0.searchKey.contains(query) }
    }

    var selectedCard: WorkspaceCard? {
        guard let selectedCardID else { return cards.first }
        return board.cards.first { $0.id == selectedCardID }
    }

    func load() async {
        board = await store.load()
        selectedCardID = board.cards.first?.id
    }

    func createCard(kind: WorkspaceCard.Kind) {
        let card = WorkspaceCard(
            id: UUID(),
            title: kind.rawValue,
            body: "",
            kind: kind,
            position: SpatialPosition(x: 140, y: 140, z: Double(board.cards.count * 30)),
            updatedAt: Date()
        )
        board.cards.insert(card, at: 0)
        selectedCardID = card.id
        Task { await store.save(board) }
    }

    func select(_ card: WorkspaceCard) {
        selectedCardID = card.id
    }

    func updateSelected(title: String, body: String) {
        updateSelected { card in
            card.title = title
            card.body = body
        }
    }

    func moveSelected(to position: SpatialPosition) {
        updateSelected { card in
            card.position = position
        }
    }

    func deleteSelected() {
        guard let selectedCardID else { return }
        board.cards.removeAll { $0.id == selectedCardID }
        self.selectedCardID = board.cards.first?.id
        Task { await store.save(board) }
    }

    private func updateSelected(_ mutate: (inout WorkspaceCard) -> Void) {
        guard let selectedCardID, let index = board.cards.firstIndex(where: { $0.id == selectedCardID }) else { return }
        mutate(&board.cards[index])
        board.cards[index].updatedAt = Date()
        Task { await store.save(board) }
    }
}
