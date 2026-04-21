import SwiftUI

@main
struct MovieSeriesBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            MovieCatalogView(viewModel: CatalogViewModel())
        }
    }
}
