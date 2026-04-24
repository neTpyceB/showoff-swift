import Combine
import Foundation

@MainActor
final class SmartHomeStore: ObservableObject {
    @Published private(set) var state: SmartHomeState {
        didSet {
            sync.save(state)
        }
    }

    let rooms = SmartRoom.allCases
    let scenes = SmartScene.allCases
    private let sync: SmartHomeSync
    private let commandCenter = SmartHomeCommandCenter()
    private var realtimeTask: Task<Void, Never>?

    init(sync: SmartHomeSync = SmartHomeSync()) {
        self.sync = sync
        state = sync.load() ?? .initial()
    }

    deinit {
        realtimeTask?.cancel()
    }

    func devices(in room: SmartRoom) -> [SmartDevice] {
        state.devices(in: room)
    }

    func execute(_ command: SmartHomeCommand) {
        var updated = state
        commandCenter.execute(command, on: &updated)
        updated.lastUpdated = Date()
        state = updated
    }

    func startRealtimeUpdates(intervalSeconds: UInt64 = 5) {
        stopRealtimeUpdates()
        realtimeTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: intervalSeconds * 1_000_000_000)
                await self?.applyRealtimeTick()
            }
        }
    }

    func stopRealtimeUpdates() {
        realtimeTask?.cancel()
        realtimeTask = nil
    }

    var lightsOnCount: Int { state.lightsOnCount }
    var activeCameraCount: Int { state.activeCameraCount }

    var averageTemperature: Int {
        let values = state.thermostats.map(\.currentTemperature)
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / values.count
    }

    private func applyRealtimeTick() {
        var updated = state
        commandCenter.applyRealtimeTick(on: &updated, at: Date())
        state = updated
    }
}
