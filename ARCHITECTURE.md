# Architecture

## Projects

- Daily Notes: iOS only.
- Habit Tracker: iOS + watchOS.
- Weather Companion: iOS + watchOS + WidgetKit.
- Movie / Series Browser: iOS + tvOS.

## Daily Notes

- `DailyNotesApp`: app entry point.
- `ContentView`: notes list and navigation.
- `NoteEditorView`: create and edit screen.
- `NotesStore`: in-memory state and UserDefaults persistence.
- `Note`: note model.

Notes are stored locally in `UserDefaults` as JSON.

## Habit Tracker

- `HabitTrackerApp`: iOS app entry point.
- `HabitListView`: habit list, progress, completion.
- `AddHabitView`: habit creation form.
- `ReminderScheduler`: local notification scheduling.
- `HabitTrackerWatchApp`: watchOS app entry point.
- `WatchHabitListView`: watch completion UI.
- `HabitStore`: UserDefaults persistence.
- `HabitSync`: shared UserDefaults app group sync.
- `Habit`: shared model.

Habits are stored locally and mirrored through app-group UserDefaults.

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

## Movie / Series Browser

- `MovieSeriesBrowserApp`: iOS app entry point.
- `MovieCatalogView`: iOS catalog and search UI.
- `MediaDetailView`: iOS media details and trailer player.
- `PosterImageView`: iOS poster loader with in-memory cache.
- `MovieSeriesBrowserTVApp`: tvOS app entry point.
- `TVMediaCatalogView`: tvOS catalog grid, focus navigation, and trailer details.
- `CatalogService`: shared movie/series catalog source.
- `CatalogViewModel`: shared catalog filtering and featured state.
- `MediaItem`, `MediaKind`: shared media model.
