import Foundation

enum SmartRoom: String, CaseIterable, Codable, Identifiable, Sendable {
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case bedroom = "Bedroom"

    var id: String { rawValue }
}

enum SmartDeviceKind: String, Codable, Sendable {
    case light
    case thermostat
    case camera
}

enum SmartScene: String, CaseIterable, Codable, Identifiable, Sendable {
    case relax
    case movie
    case away

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }
}

struct SmartDevice: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var room: SmartRoom
    var name: String
    var kind: SmartDeviceKind
    var isOn: Bool
    var brightness: Int
    var currentTemperature: Int
    var targetTemperature: Int
    var motionDetected: Bool

    init(
        id: UUID = UUID(),
        room: SmartRoom,
        name: String,
        kind: SmartDeviceKind,
        isOn: Bool = false,
        brightness: Int = 0,
        currentTemperature: Int = 0,
        targetTemperature: Int = 0,
        motionDetected: Bool = false
    ) {
        self.id = id
        self.room = room
        self.name = name
        self.kind = kind
        self.isOn = isOn
        self.brightness = brightness
        self.currentTemperature = currentTemperature
        self.targetTemperature = targetTemperature
        self.motionDetected = motionDetected
    }
}

enum SmartHomeCommand: Equatable, Sendable {
    case togglePower(UUID)
    case setBrightness(UUID, Int)
    case setTargetTemperature(UUID, Int)
    case activateScene(SmartScene)
}
