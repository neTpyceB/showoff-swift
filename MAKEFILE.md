# Commands

## Daily Notes Build

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild build -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64"
```

## Daily Notes Test

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```

## Weather Companion Test

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project WeatherCompanion.xcodeproj -scheme WeatherCompanion -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```

## Weather Companion Watch Build

```sh
WATCH_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("watchOS-26-4") }.last; puts devices.find { |device| device["name"] == "Apple Watch Series 11 (46mm)" }.fetch("udid")')
xcodebuild build -project WeatherCompanion.xcodeproj -scheme WeatherCompanionWatch -destination "platform=watchOS Simulator,id=$WATCH_SIMULATOR_ID,arch=arm64"
```
