import XCTest
@testable import MovieSeriesBrowser

@MainActor
final class CatalogViewModelTests: XCTestCase {
    func testLoadAndSearch() {
        let item1 = MediaItem(
            title: "Signal",
            kind: .series,
            synopsis: "s",
            posterURL: URL(string: "https://example.com/1.jpg")!,
            trailerURL: URL(string: "https://example.com/1.mp4")!
        )
        let item2 = MediaItem(
            title: "Dune",
            kind: .movie,
            synopsis: "s",
            posterURL: URL(string: "https://example.com/2.jpg")!,
            trailerURL: URL(string: "https://example.com/2.mp4")!
        )

        let viewModel = CatalogViewModel(service: StubCatalogService(items: [item1, item2]))
        viewModel.load()

        XCTAssertEqual(viewModel.items.count, 2)
        XCTAssertEqual(viewModel.featured.count, 2)

        viewModel.searchText = "series"
        XCTAssertEqual(viewModel.filtered.map(\.title), ["Signal"])

        viewModel.searchText = "dune"
        XCTAssertEqual(viewModel.filtered.map(\.title), ["Dune"])
    }
}

private struct StubCatalogService: CatalogProviding {
    let items: [MediaItem]

    func fetchCatalog() -> [MediaItem] {
        items
    }
}
