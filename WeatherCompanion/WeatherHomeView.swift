import SwiftUI

struct WeatherHomeView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Place", text: $viewModel.query)
                        .textInputAutocapitalization(.words)
                        .accessibilityIdentifier("place-query")

                    Button("Add Place") {
                        Task { await viewModel.addPlace() }
                    }
                    .accessibilityIdentifier("add-place")
                }

                if viewModel.isLoading {
                    ProgressView()
                        .accessibilityIdentifier("loading-weather")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .accessibilityIdentifier("weather-error")
                }

                if let report = viewModel.report {
                    Section {
                        Text("\(Int(report.temperature.rounded())) C")
                            .font(.largeTitle)
                            .accessibilityIdentifier("current-temperature")
                        Text(report.condition)
                            .accessibilityIdentifier("current-condition")
                    } header: {
                        Text(report.place.name)
                            .accessibilityIdentifier("current-place")
                    }

                    Section("Hourly") {
                        ForEach(report.hourly) { hour in
                            HStack {
                                Text(hour.time)
                                Spacer()
                                Text("\(Int(hour.temperature.rounded())) C")
                            }
                        }
                    }
                }

                Section("Favorites") {
                    ForEach(viewModel.store.places) { place in
                        Button {
                            Task { await viewModel.load(place) }
                        } label: {
                            Text("\(place.name), \(place.country)")
                        }
                        .accessibilityIdentifier("place-\(place.name)")
                    }
                    .onDelete { viewModel.store.delete(at: $0) }
                }
            }
            .navigationTitle("Weather")
            .task {
                await viewModel.loadFirst()
            }
        }
    }
}
