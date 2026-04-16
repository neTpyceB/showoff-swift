import Foundation

struct WeatherAPI {
    func searchPlace(_ query: String) async throws -> Place {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            URLQueryItem(name: "name", value: query),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        let place = response.results![0]
        return Place(name: place.name, country: place.country, latitude: place.latitude, longitude: place.longitude)
    }

    func weather(for place: Place) async throws -> WeatherReport {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(place.latitude)"),
            URLQueryItem(name: "longitude", value: "\(place.longitude)"),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code"),
            URLQueryItem(name: "hourly", value: "temperature_2m,weather_code"),
            URLQueryItem(name: "forecast_hours", value: "12"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try Self.decodeWeather(data, place: place)
    }

    static func decodeWeather(_ data: Data, place: Place) throws -> WeatherReport {
        let response = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let hourly = response.hourly.time.indices.map {
            HourlyForecast(
                time: response.hourly.time[$0],
                temperature: response.hourly.temperature2m[$0],
                weatherCode: response.hourly.weatherCode[$0]
            )
        }

        return WeatherReport(
            place: place,
            temperature: response.current.temperature2m,
            weatherCode: response.current.weatherCode,
            hourly: hourly
        )
    }
}

private struct GeocodingResponse: Decodable {
    var results: [GeocodingPlace]?
}

private struct GeocodingPlace: Decodable {
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double
}

private struct ForecastResponse: Decodable {
    var current: CurrentWeather
    var hourly: HourlyWeather
}

private struct CurrentWeather: Decodable {
    var temperature2m: Double
    var weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

private struct HourlyWeather: Decodable {
    var time: [String]
    var temperature2m: [Double]
    var weatherCode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
    }
}
