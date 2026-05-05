import XCTest
@testable import SpatialCollaboration

@MainActor
final class SpatialWorkspaceViewModelTests: XCTestCase {
    func testLoadAndSearch() async {
        let viewModel = SpatialWorkspaceViewModel()

        await viewModel.load()

        XCTAssertEqual(viewModel.board.cards.count, 3)
        XCTAssertEqual(viewModel.selectedCard?.title, "North Star")

        viewModel.searchText = "media"
        XCTAssertEqual(viewModel.cards.map(\.title), ["Storyboard"])
    }

    func testCreateMoveAndDeleteCard() async {
        let viewModel = SpatialWorkspaceViewModel()

        await viewModel.load()
        viewModel.createCard(kind: .data)

        XCTAssertEqual(viewModel.selectedCard?.kind, .data)

        viewModel.moveSelected(to: SpatialPosition(x: 1, y: 2, z: 3))

        XCTAssertEqual(viewModel.selectedCard?.position, SpatialPosition(x: 1, y: 2, z: 3))

        viewModel.deleteSelected()

        XCTAssertEqual(viewModel.board.cards.count, 3)
    }
}
