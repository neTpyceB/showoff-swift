# Commands

## Build

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild build -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64"
```

## Test

```sh
SIMULATOR_ID=$(xcrun simctl list devices available -j | ruby -rjson -e 'devices = JSON.parse(STDIN.read)["devices"].find { |runtime, _| runtime.end_with?("iOS-26-4") }.last; puts devices.find { |device| device["name"] == "iPhone 17" }.fetch("udid")')
xcodebuild test -project DailyNotes.xcodeproj -scheme DailyNotes -destination "platform=iOS Simulator,id=$SIMULATOR_ID,arch=arm64"
```
