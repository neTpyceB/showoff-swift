# Showoff Swift

Independent Apple app projects.

## Requirements

- Xcode 26.4
- iOS Simulator 26.4
- watchOS Simulator 26.4

## Apps

- `DailyNotes.xcodeproj`: iOS notes app.
- `HabitTracker.xcodeproj`: iOS + watchOS habit tracker.

## Daily Notes

Open `DailyNotes.xcodeproj` in Xcode and run the `DailyNotes` scheme on an iPhone simulator.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```

## Habit Tracker

Open `HabitTracker.xcodeproj` in Xcode. Run `HabitTracker` on iPhone and `HabitTrackerWatch` on Apple Watch.

```sh
IOS_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
export IOS_SIMULATOR_ID
WATCH_SIMULATOR_ID=$(xcrun simctl list pairs -j | ruby -rjson -e 'pairs = JSON.parse(STDIN.read)["pairs"].values; puts pairs.find { |pair| pair.fetch("phone").fetch("udid") == ENV.fetch("IOS_SIMULATOR_ID") }.fetch("watch").fetch("udid")')
xcodebuild test -project HabitTracker.xcodeproj -scheme HabitTracker -destination "platform=iOS Simulator,id=$IOS_SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
xcodebuild build -project HabitTracker.xcodeproj -scheme HabitTrackerWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```
