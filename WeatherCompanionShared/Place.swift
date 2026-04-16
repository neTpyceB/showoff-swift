import Foundation

struct Place: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double

    init(id: UUID = UUID(), name: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }

    static let berlin = Place(name: "Berlin", country: "Germany", latitude: 52.52, longitude: 13.41)
}
