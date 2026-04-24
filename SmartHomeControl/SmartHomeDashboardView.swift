import SwiftUI

struct SmartHomeDashboardView: View {
    @ObservedObject var store: SmartHomeStore
    @State private var selectedRoom: SmartRoom = .livingRoom

    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    statRow("Lights On", "\(store.lightsOnCount)", identifier: "lights-on-count")
                    statRow("Cameras Active", "\(store.activeCameraCount)", identifier: "cameras-active-count")
                    statRow("Avg Temperature", "\(store.averageTemperature) C", identifier: "avg-temperature")
                }

                Section("Room") {
                    Picker("Room", selection: $selectedRoom) {
                        ForEach(store.rooms) { room in
                            Text(room.rawValue).tag(room)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("room-picker")
                }

                Section("Devices") {
                    ForEach(store.devices(in: selectedRoom)) { device in
                        DeviceControlRow(device: device) { command in
                            store.execute(command)
                        }
                    }
                }

                Section("Scenes") {
                    ForEach(store.scenes) { scene in
                        Button(scene.title) {
                            store.execute(.activateScene(scene))
                        }
                        .accessibilityIdentifier("scene-\(scene.rawValue)")
                    }
                }
            }
            .navigationTitle("Smart Home")
        }
    }

    private func statRow(_ title: String, _ value: String, identifier: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .accessibilityIdentifier(identifier)
        }
    }
}

private struct DeviceControlRow: View {
    let device: SmartDevice
    let apply: (SmartHomeCommand) -> Void

    var body: some View {
        switch device.kind {
        case .light:
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(device.name, systemImage: "lightbulb")
                    Spacer()
                    Button(device.isOn ? "On" : "Off") {
                        apply(.togglePower(device.id))
                    }
                    .accessibilityIdentifier("toggle-\(device.id.uuidString)")
                }
                Stepper("\(device.brightness)%", value: brightnessBinding, in: 0 ... 100, step: 10)
            }

        case .thermostat:
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(device.name, systemImage: "thermometer")
                    Spacer()
                    Text("\(device.currentTemperature) C")
                }
                Stepper("Target \(device.targetTemperature) C", value: targetBinding, in: 16 ... 30)
            }

        case .camera:
            HStack {
                Label(device.name, systemImage: "video")
                Spacer()
                if device.motionDetected {
                    Text("Motion")
                        .font(.caption)
                }
                Button(device.isOn ? "On" : "Off") {
                    apply(.togglePower(device.id))
                }
                .accessibilityIdentifier("toggle-\(device.id.uuidString)")
            }
        }
    }

    private var brightnessBinding: Binding<Int> {
        Binding(
            get: { device.brightness },
            set: { apply(.setBrightness(device.id, $0)) }
        )
    }

    private var targetBinding: Binding<Int> {
        Binding(
            get: { device.targetTemperature },
            set: { apply(.setTargetTemperature(device.id, $0)) }
        )
    }
}
