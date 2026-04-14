# Architecture

## Platform

iOS only.

## App

- `DailyNotesApp`: app entry point.
- `ContentView`: notes list and navigation.
- `NoteEditorView`: create and edit screen.
- `NotesStore`: in-memory state and UserDefaults persistence.
- `Note`: note model.

## Storage

Notes are stored locally in `UserDefaults` as JSON.
