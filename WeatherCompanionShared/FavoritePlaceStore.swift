import Combine
import Foundation

@MainActor
final class FavoritePlaceStore: ObservableObject {
    @Published private(set) var places: [Place] {
        didSet { save() }
    }

    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "weather.places") {
        self.defaults = defaults
        self.key = key
        places = defaults.data(forKey: key).map { try! JSONDecoder().decode([Place].self, from: $0) } ?? [.berlin]
    }

    func add(_ place: Place) {
        places.append(place)
    }

    func delete(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
    }

    private func save() {
        defaults.set(try! JSONEncoder().encode(places), forKey: key)
    }
}
