# Showoff Swift

Independent Apple app projects.

## Requirements

- Xcode 26.4.1
- iOS Simulator 26.4
- watchOS Simulator 26.4
- tvOS Simulator 26.4

## Apps

- `DailyNotes.xcodeproj`: iOS notes app.
- `HabitTracker.xcodeproj`: iOS + watchOS habit tracker.
- `WeatherCompanion.xcodeproj`: iOS + watchOS + WidgetKit weather app.
- `MovieSeriesBrowser.xcodeproj`: iOS + tvOS movie and series browser.
- `FitnessDashboard.xcodeproj`: iOS + watchOS personal fitness dashboard.
- `SmartHomeControl.xcodeproj`: iOS + watchOS + tvOS smart home control app.
- `FieldServiceApp.xcodeproj`: iOS + watchOS offline-first field service app.

## Daily Notes

Open `DailyNotes.xcodeproj` in Xcode and run the `DailyNotes` scheme on an iPhone simulator.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```

## Habit Tracker

Open `HabitTracker.xcodeproj` in Xcode. Run `HabitTracker` on iPhone and `HabitTrackerWatch` on Apple Watch.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
xcodebuild test -project HabitTracker.xcodeproj -scheme HabitTracker -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project HabitTracker.xcodeproj -scheme HabitTrackerWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```

## Weather Companion

Open `WeatherCompanion.xcodeproj` in Xcode. Run `WeatherCompanion` on iPhone and `WeatherCompanionWatch` on Apple Watch.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
xcodebuild test -project WeatherCompanion.xcodeproj -scheme WeatherCompanion -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project WeatherCompanion.xcodeproj -scheme WeatherCompanionWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```

## Movie / Series Browser

Open `MovieSeriesBrowser.xcodeproj` in Xcode. Run `MovieSeriesBrowser` on iPhone and `MovieSeriesBrowserTV` on Apple TV.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
TV_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("tvOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple TV 4K (3rd generation)" }.fetch("udid")')
xcodebuild test -project MovieSeriesBrowser.xcodeproj -scheme MovieSeriesBrowser -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project MovieSeriesBrowser.xcodeproj -scheme MovieSeriesBrowserTV -destination "platform=tvOS Simulator,id=$TV_SIMULATOR_ID,arch=arm64"
```

## Personal Fitness Dashboard

Open `FitnessDashboard.xcodeproj` in Xcode. Run `FitnessDashboard` on iPhone and `FitnessDashboardWatch` on Apple Watch.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
xcodebuild test -project FitnessDashboard.xcodeproj -scheme FitnessDashboard -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project FitnessDashboard.xcodeproj -scheme FitnessDashboardWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```

## Smart Home Control App

Open `SmartHomeControl.xcodeproj` in Xcode. Run `SmartHomeControl` on iPhone, `SmartHomeControlWatch` on Apple Watch, and `SmartHomeControlTV` on Apple TV.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
TV_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("tvOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple TV 4K (3rd generation)" }.fetch("udid")')
xcodebuild test -project SmartHomeControl.xcodeproj -scheme SmartHomeControl -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project SmartHomeControl.xcodeproj -scheme SmartHomeControlWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
xcodebuild build -project SmartHomeControl.xcodeproj -scheme SmartHomeControlTV -destination "platform=tvOS Simulator,id=$TV_SIMULATOR_ID,arch=arm64"
```

## Offline-first Field Service App

Open `FieldServiceApp.xcodeproj` in Xcode. Run `FieldServiceApp` on iPhone and `FieldServiceAppWatch` on Apple Watch.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
xcodebuild test -project FieldServiceApp.xcodeproj -scheme FieldServiceApp -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project FieldServiceApp.xcodeproj -scheme FieldServiceAppWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```
