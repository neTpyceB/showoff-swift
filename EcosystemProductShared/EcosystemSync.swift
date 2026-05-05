import Foundation

struct EcosystemSync {
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "ecosystem.state") {
        self.defaults = defaults
        self.key = key
    }

    func load() -> EcosystemState? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(EcosystemState.self, from: data)
    }

    func save(_ state: EcosystemState) {
        defaults.set(try! JSONEncoder().encode(state), forKey: key)
    }
}
