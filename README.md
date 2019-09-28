# Time

[![](https://img.shields.io/badge/Swift-5.0-orange.svg)][1]
[![](https://img.shields.io/badge/os-macOS%20|%20Linux-lightgray.svg)][1]
[![](https://travis-ci.com/std-swift/Time.svg?branch=master)][2]
[![](https://codecov.io/gh/std-swift/Time/branch/master/graph/badge.svg)][3]
[![](https://codebeat.co/badges/2fb32876-8443-4b0b-9948-6babe2ccef97)][4]

[1]: https://swift.org/download/#releases
[2]: https://travis-ci.com/std-swift/Time
[3]: https://codecov.io/gh/std-swift/Time
[4]: https://codebeat.co/projects/github-com-std-swift-time-master

Provides clocks for keeping track of time

## Importing

```Swift
import Time
```

```Swift
platforms: [
	.macOS(.v10_12)
],
dependencies: [
	.package(url: "https://github.com/std-swift/Time.git",
	         from: "1.0.0")
],
targets: [
	.target(
		name: "",
		dependencies: [
			"Time"
		]),
]
```

## Using

### `Clock`

- `.realtime` Get the amount of time since the Epoch
- `.monotonic` Get the amount of time since an arbitrary point
- `.process` Get the amount of CPU time the process has been running for
- `.thread` Get the amount of CPU time the thread has been running for

`.now() -> Time` returns the current time according to the `Clock`

### `Time`

Contains `.seconds` and `.nanoseconds`

`.view` provides a `Time.View` which gives access to different representations of the time (`.seconds`, `.milliseconds`, `.microseconds`, `.nanoseconds`) 

- `Time.distantPast` is always in the past
- `Time.distantFuture` is always in the future

Supported operations:

```Swift
static func - (lhs: Time, rhs: Time) -> Timeout
static func + (lhs: Time, rhs: Timeout) -> Time
static func - (lhs: Time, rhs: Timeout) -> Time
```

### `Timeout`

Represents a time interval in nanoseconds

```Swift
.always
.never
.nanoseconds(_:)
.microseconds(_:)
.milliseconds(_:)
.seconds(_:)
.minutes(_:)
.hours(_:)
```

Supported operations:

```Swift
static func + (lhs: Timeout, rhs: Timeout) -> Timeout
static func - (lhs: Timeout, rhs: Timeout) -> Timeout
static func * <T: BinaryInteger>(lhs: T, rhs: Timeout) -> Timeout
static func * <T: BinaryInteger>(lhs: Timeout, rhs: T) -> Timeout
```

### `Deadline`

Represents a point in time relative to some fixed time in the past

- `.always` A deadline in the past that is always reached
- `.never` A deadline in the future that is never reached
- `.now()` The current time

Supported operations:

```Swift
static func - (lhs: Deadline, rhs: Deadline) -> Timeout
static func + (lhs: Deadline, rhs: Timeout) -> Deadline
static func - (lhs: Deadline, rhs: Timeout) -> Deadline
```
