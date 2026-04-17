# Showoff Swift

Independent Apple app projects.

## Requirements

- Xcode 26.4.1
- iOS Simulator 26.4
- watchOS Simulator 26.4

## Apps

- `DailyNotes.xcodeproj`: iOS notes app.
- `HabitTracker.xcodeproj`: iOS + watchOS habit tracker.
- `WeatherCompanion.xcodeproj`: iOS + watchOS + WidgetKit weather app.

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
