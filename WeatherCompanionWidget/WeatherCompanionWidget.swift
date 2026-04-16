import SwiftUI
@preconcurrency import WidgetKit

struct WeatherEntry: TimelineEntry {
    let date: Date
    let report: WeatherReport?
}

struct WeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), report: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        completion(WeatherEntry(date: Date(), report: nil))
    }

    @preconcurrency func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<WeatherEntry>) -> Void) {
        Task {
            let report = try? await WeatherAPI().weather(for: .berlin)
            let entry = WeatherEntry(date: Date(), report: report)
            completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800))))
        }
    }
}

struct WeatherWidgetView: View {
    let entry: WeatherEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.report?.place.name ?? "Weather")
                .font(.headline)
            Text(entry.report.map { "\(Int($0.temperature.rounded())) C" } ?? "--")
                .font(.title)
            Text(entry.report?.condition ?? "Loading")
                .font(.caption)
        }
    }
}

struct WeatherCompanionWidget: Widget {
    let kind = "WeatherCompanionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Weather")
        .description("Current weather.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct WeatherCompanionWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherCompanionWidget()
    }
}
