import Foundation

struct SmartHomeState: Codable, Equatable, Sendable {
    var devices: [SmartDevice]
    var lastUpdated: Date

    static func initial() -> SmartHomeState {
        SmartHomeState(
            devices: [
                SmartDevice(room: .livingRoom, name: "Main Light", kind: .light, isOn: true, brightness: 70),
                SmartDevice(room: .livingRoom, name: "Thermostat", kind: .thermostat, isOn: true, currentTemperature: 21, targetTemperature: 22),
                SmartDevice(room: .livingRoom, name: "Front Camera", kind: .camera, isOn: true, motionDetected: false),
                SmartDevice(room: .kitchen, name: "Ceiling Light", kind: .light, isOn: false, brightness: 0),
                SmartDevice(room: .kitchen, name: "Kitchen Camera", kind: .camera, isOn: false, motionDetected: false),
                SmartDevice(room: .bedroom, name: "Bedside Light", kind: .light, isOn: true, brightness: 35),
                SmartDevice(room: .bedroom, name: "Bedroom Thermostat", kind: .thermostat, isOn: true, currentTemperature: 20, targetTemperature: 20)
            ],
            lastUpdated: Date()
        )
    }
}

extension SmartHomeState {
    func devices(in room: SmartRoom) -> [SmartDevice] {
        devices.filter { $0.room == room }
    }

    var lightsOnCount: Int {
        devices.filter { $0.kind == .light && $0.isOn }.count
    }

    var activeCameraCount: Int {
        devices.filter { $0.kind == .camera && $0.isOn }.count
    }

    var thermostats: [SmartDevice] {
        devices.filter { $0.kind == .thermostat }
    }
}
