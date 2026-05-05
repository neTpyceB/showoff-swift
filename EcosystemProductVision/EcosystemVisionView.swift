import SwiftUI

struct EcosystemVisionView: View {
    @ObservedObject var store: EcosystemStore

    var body: some View {
        VStack(spacing: 24) {
            Text("Ecosystem Control")
                .font(.largeTitle)

            HStack(spacing: 16) {
                metric("Lights", "\(store.lightsOnCount)")
                metric("Cameras", "\(store.activeCameraCount)")
                metric("Avg Temp", "\(store.averageTemperature) C")
            }

            HStack(spacing: 12) {
                ForEach(store.scenes) { scene in
                    Button(scene.title) {
                        store.execute(.activateScene(scene))
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(32)
    }

    private func metric(_ title: String, _ value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.title2)
        }
        .frame(minWidth: 140, minHeight: 120)
    }
}
