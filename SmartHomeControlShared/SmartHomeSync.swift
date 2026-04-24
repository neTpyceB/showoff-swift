import Foundation

struct SmartHomeSync {
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "smarthome.state") {
        self.defaults = defaults
        self.key = key
    }

    func load() -> SmartHomeState? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(SmartHomeState.self, from: data)
    }

    func save(_ state: SmartHomeState) {
        defaults.set(try! JSONEncoder().encode(state), forKey: key)
    }
}
