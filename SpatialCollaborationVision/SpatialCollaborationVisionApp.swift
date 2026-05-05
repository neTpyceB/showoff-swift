import SwiftUI

@main
struct SpatialCollaborationVisionApp: App {
    @StateObject private var viewModel = SpatialWorkspaceViewModel()

    var body: some Scene {
        WindowGroup {
            SpatialWorkspaceView(viewModel: viewModel)
                .task { await viewModel.load() }
        }
        .windowStyle(.volumetric)
    }
}
