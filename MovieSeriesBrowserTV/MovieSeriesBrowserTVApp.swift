import SwiftUI

@main
struct MovieSeriesBrowserTVApp: App {
    var body: some Scene {
        WindowGroup {
            TVMediaCatalogView(viewModel: CatalogViewModel())
        }
    }
}
