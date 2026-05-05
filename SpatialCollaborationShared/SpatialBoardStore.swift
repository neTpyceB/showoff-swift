import Foundation

actor SpatialBoardStore {
    private var board = WorkspaceBoard(
        id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
        title: "Launch Workspace",
        cards: [
            WorkspaceCard(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333334")!,
                title: "North Star",
                body: "Shared goal and constraints",
                kind: .note,
                position: SpatialPosition(x: 70, y: 90, z: 0),
                updatedAt: Date(timeIntervalSince1970: 300)
            ),
            WorkspaceCard(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333335")!,
                title: "Storyboard",
                body: "Media references for the room",
                kind: .media,
                position: SpatialPosition(x: 210, y: 170, z: 40),
                updatedAt: Date(timeIntervalSince1970: 200)
            ),
            WorkspaceCard(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333336")!,
                title: "Metrics",
                body: "Budget, timing, and owners",
                kind: .data,
                position: SpatialPosition(x: 120, y: 280, z: 80),
                updatedAt: Date(timeIntervalSince1970: 100)
            )
        ]
    )

    func load() -> WorkspaceBoard {
        board
    }

    func save(_ board: WorkspaceBoard) {
        self.board = board
    }
}
