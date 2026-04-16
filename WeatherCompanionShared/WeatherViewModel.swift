import Combine
import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var report: WeatherReport?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var query = ""

    let store: FavoritePlaceStore
    private let api = WeatherAPI()

    init(store: FavoritePlaceStore = FavoritePlaceStore()) {
        self.store = store
    }

    func load(_ place: Place) async {
        isLoading = true
        errorMessage = nil

        do {
            report = try await api.weather(for: place)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadFirst() async {
        await load(store.places[0])
    }

    func addPlace() async {
        isLoading = true
        errorMessage = nil

        do {
            let place = try await api.searchPlace(query)
            store.add(place)
            query = ""
            await load(place)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
