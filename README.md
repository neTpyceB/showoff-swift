# Showoff Swift

Independent SwiftUI learning apps.

## Apps

- `DailyNotes.xcodeproj`: iOS notes app.
- `WeatherCompanion.xcodeproj`: iOS, watchOS, and widget weather app.

## Requirements

- Xcode 26.4
- iOS Simulator 26.4
- watchOS Simulator 26.4

## Daily Notes

Open `DailyNotes.xcodeproj` in Xcode and run the `DailyNotes` scheme on an iPhone simulator.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64"
```

## Weather Companion

Open `WeatherCompanion.xcodeproj` in Xcode and run:

- `WeatherCompanion` on an iPhone simulator.
- `WeatherCompanionWatch` on an Apple Watch simulator.

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project WeatherCompanion.xcodeproj -scheme WeatherCompanion -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```
