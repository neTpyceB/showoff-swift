import XCTest
@testable import WeatherCompanion

final class WeatherAPITests: XCTestCase {
    func testDecodeWeather() throws {
        let json = """
        {
          "current": { "temperature_2m": 12.4, "weather_code": 1 },
          "hourly": {
            "time": ["2026-04-16T10:00", "2026-04-16T11:00"],
            "temperature_2m": [12.4, 13.0],
            "weather_code": [1, 2]
          }
        }
        """.data(using: .utf8)!

        let report = try WeatherAPI.decodeWeather(json, place: .berlin)

        XCTAssertEqual(report.place.name, "Berlin")
        XCTAssertEqual(report.temperature, 12.4)
        XCTAssertEqual(report.condition, "Cloudy")
        XCTAssertEqual(report.hourly.count, 2)
    }

    func testDecodeWeatherWithSingleHour() throws {
        let json = """
        {
          "current": { "temperature_2m": 8.0, "weather_code": 3 },
          "hourly": {
            "time": ["2026-04-16T12:00"],
            "temperature_2m": [8.0],
            "weather_code": [3]
          }
        }
        """.data(using: .utf8)!

        let report = try WeatherAPI.decodeWeather(json, place: .berlin)

        XCTAssertEqual(report.temperature, 8.0)
        XCTAssertEqual(report.condition, "Cloudy")
        XCTAssertEqual(report.hourly.count, 1)
    }
}
