import Foundation

struct FitnessPermissionManager {
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults, key: String) {
        self.defaults = defaults
        self.key = key
    }

    func load() -> PermissionState {
        guard let raw = defaults.string(forKey: key) else {
            return .unknown
        }

        return PermissionState(rawValue: raw) ?? .unknown
    }

    func save(_ state: PermissionState) {
        defaults.set(state.rawValue, forKey: key)
    }
}
