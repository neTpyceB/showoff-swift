# Architecture

## Projects

- Daily Notes: iOS only.
- Weather Companion: iOS, watchOS, WidgetKit.

## Daily Notes

- `DailyNotesApp`: app entry point.
- `ContentView`: notes list and navigation.
- `NoteEditorView`: create and edit screen.
- `NotesStore`: in-memory state and UserDefaults persistence.
- `Note`: note model.

Notes are stored locally in `UserDefaults` as JSON.

## Weather Companion

- `WeatherCompanionApp`: iOS app entry point.
- `WeatherHomeView`: favorites, current weather, hourly forecast.
- `WeatherCompanionWatchApp`: watchOS app entry point.
- `WatchWeatherView`: watch quick view.
- `WeatherCompanionWidget`: WidgetKit extension.
- `WeatherAPI`: Open-Meteo networking and JSON decoding.
- `WeatherViewModel`: async loading state.
- `FavoritePlaceStore`: UserDefaults favorite places.
- `Place`, `WeatherReport`, `HourlyForecast`: shared models.
