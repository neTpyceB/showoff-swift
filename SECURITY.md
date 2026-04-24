# Security

## Authentication

None.

## Authorization

None.

## Data

- Daily Notes stores notes on device in UserDefaults.
- Habit Tracker stores habits on device and app-group UserDefaults.
- Weather Companion stores favorite places on device in UserDefaults.
- Personal Fitness Dashboard stores workouts and permission state on device in UserDefaults.
- Smart Home Control App stores room/device state on device in UserDefaults.

## Network

- Weather Companion calls Open-Meteo over HTTPS.
- Movie / Series Browser loads poster and trailer media over HTTPS.
- Smart Home Control App has no external network calls.

## Notifications

Habit Tracker schedules local notifications only after user permission.
Personal Fitness Dashboard schedules local notifications only after user permission.
