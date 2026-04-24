import Foundation

struct SmartHomeCommandCenter {
    func execute(_ command: SmartHomeCommand, on state: inout SmartHomeState) {
        switch command {
        case .togglePower(let deviceID):
            guard let index = state.devices.firstIndex(where: { $0.id == deviceID }) else { return }
            state.devices[index].isOn.toggle()
            if state.devices[index].kind == .light && !state.devices[index].isOn {
                state.devices[index].brightness = 0
            }
            if state.devices[index].kind == .light && state.devices[index].isOn && state.devices[index].brightness == 0 {
                state.devices[index].brightness = 50
            }

        case .setBrightness(let deviceID, let value):
            guard let index = state.devices.firstIndex(where: { $0.id == deviceID }) else { return }
            guard state.devices[index].kind == .light else { return }
            state.devices[index].brightness = min(max(value, 0), 100)
            state.devices[index].isOn = state.devices[index].brightness > 0

        case .setTargetTemperature(let deviceID, let target):
            guard let index = state.devices.firstIndex(where: { $0.id == deviceID }) else { return }
            guard state.devices[index].kind == .thermostat else { return }
            state.devices[index].targetTemperature = min(max(target, 16), 30)

        case .activateScene(let scene):
            applyScene(scene, on: &state)
        }
    }

    func applyRealtimeTick(on state: inout SmartHomeState, at date: Date) {
        let second = Calendar.current.component(.second, from: date)

        for index in state.devices.indices {
            switch state.devices[index].kind {
            case .thermostat:
                let current = state.devices[index].currentTemperature
                let target = state.devices[index].targetTemperature
                if current < target {
                    state.devices[index].currentTemperature += 1
                } else if current > target {
                    state.devices[index].currentTemperature -= 1
                }

            case .camera:
                state.devices[index].motionDetected = state.devices[index].isOn && second % 2 == 0

            case .light:
                continue
            }
        }

        state.lastUpdated = date
    }

    private func applyScene(_ scene: SmartScene, on state: inout SmartHomeState) {
        switch scene {
        case .relax:
            for index in state.devices.indices {
                if state.devices[index].kind == .light {
                    state.devices[index].isOn = true
                    state.devices[index].brightness = 40
                }
                if state.devices[index].kind == .thermostat {
                    state.devices[index].targetTemperature = 22
                }
            }

        case .movie:
            for index in state.devices.indices {
                if state.devices[index].kind == .light {
                    state.devices[index].isOn = true
                    state.devices[index].brightness = 20
                }
                if state.devices[index].kind == .camera {
                    state.devices[index].isOn = false
                    state.devices[index].motionDetected = false
                }
            }

        case .away:
            for index in state.devices.indices {
                if state.devices[index].kind == .light {
                    state.devices[index].isOn = false
                    state.devices[index].brightness = 0
                }
                if state.devices[index].kind == .thermostat {
                    state.devices[index].targetTemperature = 18
                }
                if state.devices[index].kind == .camera {
                    state.devices[index].isOn = true
                }
            }
        }

        state.lastUpdated = Date()
    }
}
