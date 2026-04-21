import Foundation

@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var items: [MediaItem] = []
    @Published var searchText = ""

    private let service: CatalogProviding

    init(service: CatalogProviding = CatalogService()) {
        self.service = service
    }

    func load() {
        items = service.fetchCatalog()
    }

    var featured: [MediaItem] {
        Array(filtered.prefix(4))
    }

    var filtered: [MediaItem] {
        guard !searchText.isEmpty else { return items }
        let query = searchText.lowercased()
        return items.filter { $0.searchKey.contains(query) }
    }
}
