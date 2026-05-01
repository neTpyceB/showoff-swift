import SwiftUI

struct CardDetailView: View {
    let card: WorkspaceCard
    @ObservedObject var viewModel: SpatialWorkspaceViewModel
    @State private var title: String
    @State private var bodyText: String

    init(card: WorkspaceCard, viewModel: SpatialWorkspaceViewModel) {
        self.card = card
        self.viewModel = viewModel
        _title = State(initialValue: card.title)
        _bodyText = State(initialValue: card.body)
    }

    var body: some View {
        Form {
            Section("Card") {
                TextField("Title", text: $title)
                    .accessibilityIdentifier("card-title")
                TextEditor(text: $bodyText)
                    .frame(minHeight: 160)
                    .accessibilityIdentifier("card-body")
            }

            Section("Position") {
                Stepper("X \(Int(card.position.x))", value: xBinding, in: 0...320)
                Stepper("Y \(Int(card.position.y))", value: yBinding, in: 0...420)
                Stepper("Depth \(Int(card.position.z))", value: zBinding, in: 0...200)
            }
        }
        .navigationTitle(card.kind.rawValue)
        .toolbar {
            Button {
                viewModel.updateSelected(title: title, body: bodyText)
            } label: {
                Image(systemName: "checkmark")
            }
            .accessibilityIdentifier("save-card")

            Button(role: .destructive) {
                viewModel.deleteSelected()
            } label: {
                Image(systemName: "trash")
            }
        }
        .onChange(of: card.id) { _, _ in
            title = card.title
            bodyText = card.body
        }
    }

    private var xBinding: Binding<Double> {
        Binding(
            get: { card.position.x },
            set: { viewModel.moveSelected(to: SpatialPosition(x: $0, y: card.position.y, z: card.position.z)) }
        )
    }

    private var yBinding: Binding<Double> {
        Binding(
            get: { card.position.y },
            set: { viewModel.moveSelected(to: SpatialPosition(x: card.position.x, y: $0, z: card.position.z)) }
        )
    }

    private var zBinding: Binding<Double> {
        Binding(
            get: { card.position.z },
            set: { viewModel.moveSelected(to: SpatialPosition(x: card.position.x, y: card.position.y, z: $0)) }
        )
    }
}
