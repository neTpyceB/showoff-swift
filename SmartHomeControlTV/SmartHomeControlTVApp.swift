import SwiftUI

@main
struct SmartHomeControlTVApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = SmartHomeStore()

    var body: some Scene {
        WindowGroup {
            TVSmartHomeView(store: store)
        }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                store.startRealtimeUpdates(intervalSeconds: 5)
            } else {
                store.stopRealtimeUpdates()
            }
        }
    }
}

private struct TVSmartHomeView: View {
    @ObservedObject var store: SmartHomeStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Lights \(store.lightsOnCount)   Cameras \(store.activeCameraCount)   Avg \(store.averageTemperature) C")
                            .font(.title3)
                            .accessibilityIdentifier("tv-overview")
                        Text("Updated \(store.state.lastUpdated.formatted(date: .omitted, time: .standard))")
                            .font(.caption)
                    }

                    HStack(spacing: 20) {
                        ForEach(store.scenes) { scene in
                            Button(scene.title) {
                                store.execute(.activateScene(scene))
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("tv-scene-\(scene.rawValue)")
                        }
                    }

                    ForEach(store.rooms) { room in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(room.rawValue)
                                .font(.title2)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 260), spacing: 16)], spacing: 16) {
                                ForEach(store.devices(in: room)) { device in
                                    TVDeviceTile(device: device) {
                                        switch device.kind {
                                        case .light, .camera:
                                            store.execute(.togglePower(device.id))
                                        case .thermostat:
                                            store.execute(.setTargetTemperature(device.id, device.targetTemperature + 1))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(32)
            }
            .navigationTitle("Smart Home TV")
        }
    }
}

private struct TVDeviceTile: View {
    let device: SmartDevice
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(device.name)
                    .font(.headline)
                Text(status)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .padding(18)
            .background(Color.secondary.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private var status: String {
        switch device.kind {
        case .light:
            return device.isOn ? "On \(device.brightness)%" : "Off"
        case .thermostat:
            return "\(device.currentTemperature) C / Target \(device.targetTemperature) C"
        case .camera:
            return device.isOn ? (device.motionDetected ? "On • Motion" : "On • Clear") : "Off"
        }
    }
}
