import SwiftUI

struct WatchSmartHomeView: View {
    @ObservedObject var store: SmartHomeStore

    var body: some View {
        List {
            Section("Summary") {
                Text("Lights \(store.lightsOnCount)")
                Text("Cameras \(store.activeCameraCount)")
            }

            Section("Scenes") {
                ForEach(store.scenes) { scene in
                    Button(scene.title) {
                        store.execute(.activateScene(scene))
                    }
                    .accessibilityIdentifier("watch-scene-\(scene.rawValue)")
                }
            }

            Section("Living Room") {
                ForEach(store.devices(in: .livingRoom).filter { $0.kind != .thermostat }) { device in
                    Button(device.name) {
                        store.execute(.togglePower(device.id))
                    }
                }
            }
        }
        .navigationTitle("Smart Home")
    }
}
