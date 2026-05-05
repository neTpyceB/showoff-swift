import SwiftUI

@main
struct SpatialCollaborationApp: App {
    @StateObject private var viewModel = SpatialWorkspaceViewModel()

    var body: some Scene {
        WindowGroup {
            WorkspaceBoardView(viewModel: viewModel)
                .task { await viewModel.load() }
        }
    }
}
