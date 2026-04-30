import Foundation

struct StreamingMediaSync {
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "streaming.state") {
        self.defaults = defaults
        self.key = key
    }

    func load() -> StreamingMediaState? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(StreamingMediaState.self, from: data)
    }

    func save(_ state: StreamingMediaState) {
        defaults.set(try! JSONEncoder().encode(state), forKey: key)
    }
}
