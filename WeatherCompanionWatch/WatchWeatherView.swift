import SwiftUI

struct WatchWeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            }

            if let report = viewModel.report {
                Text(report.place.name)
                    .font(.headline)
                Text("\(Int(report.temperature.rounded())) C")
                    .font(.title2)
                Text(report.condition)
                ForEach(report.hourly.prefix(4)) { hour in
                    HStack {
                        Text(hour.time.suffix(5))
                        Spacer()
                        Text("\(Int(hour.temperature.rounded())) C")
                    }
                }
            }
        }
        .task {
            await viewModel.loadFirst()
        }
    }
}
