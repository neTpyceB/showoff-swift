import Foundation

struct WeatherReport: Equatable, Sendable {
    var place: Place
    var temperature: Double
    var weatherCode: Int
    var hourly: [HourlyForecast]

    var condition: String {
        switch weatherCode {
        case 0: "Clear"
        case 1...3: "Cloudy"
        case 45, 48: "Fog"
        case 51...67, 80...82: "Rain"
        case 71...77, 85...86: "Snow"
        case 95...99: "Storm"
        default: "Weather"
        }
    }
}

struct HourlyForecast: Identifiable, Equatable, Sendable {
    var time: String
    var temperature: Double
    var weatherCode: Int

    var id: String { time }
}
