# Architecture

## Projects

- `DailyNotes.xcodeproj`: independent iOS app.
- `HabitTracker.xcodeproj`: independent iOS + watchOS app.

## Daily Notes

- `DailyNotesApp`: app entry point.
- `ContentView`: notes list and navigation.
- `NoteEditorView`: create and edit screen.
- `NotesStore`: in-memory state and UserDefaults persistence.
- `Note`: note model.

## Storage

Notes are stored locally in `UserDefaults` as JSON.

## Habit Tracker

- `HabitTrackerApp`: iOS app entry point.
- `HabitTrackerWatchApp`: watchOS app entry point.
- `HabitListView`: iOS habit list, progress, add, delete, done.
- `WatchHabitListView`: watchOS habit list and done action.
- `HabitStore`: shared state and UserDefaults persistence.
- `HabitSync`: WatchConnectivity snapshot and done sync.
- `ReminderScheduler`: daily local notification.
- `Habit`: shared habit model.

## Habit Storage

Habits are stored locally in `UserDefaults` as JSON.
