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

## Habit Tracker iOS Test

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project HabitTracker.xcodeproj -scheme HabitTracker -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64" -parallel-testing-enabled NO
```

## Habit Tracker watchOS Build

```sh
IOS_SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
export IOS_SIMULATOR_ID
SIMULATOR_ID=$(xcrun simctl list pairs -j | ruby -rjson -e 'pairs = JSON.parse(STDIN.read)["pairs"].values; puts pairs.find { |pair| pair.fetch("phone").fetch("udid") == ENV.fetch("IOS_SIMULATOR_ID") }.fetch("watch").fetch("udid")')
xcodebuild build -project HabitTracker.xcodeproj -scheme HabitTrackerWatch -destination "platform=watchOS Simulator,id=$SIMULATOR_ID,arch=arm64"
```
