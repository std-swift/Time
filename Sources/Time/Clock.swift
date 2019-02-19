//
//  Clock.swift
//  Time
//

#if os(macOS)
import Darwin.C.time
#endif

#if os(Linux)
import SwiftGlibc.C.time
#endif

/// A source of time
///
/// - `.realtime` Get the amount of time since the Epoch
/// - `.monotonic` Get the amount of time since an arbitrary point
/// - `.process` Get the amount of CPU time the process has been running for
/// - `.thread` Get the amount of CPU time the thread has been running for
public struct Clock {
	public static let realtime = Clock(CLOCK_REALTIME)
	public static let monotonic = Clock(CLOCK_MONOTONIC)
	public static let process = Clock(CLOCK_PROCESS_CPUTIME_ID)
	public static let thread = Clock(CLOCK_THREAD_CPUTIME_ID)
	
	private let clockID: clockid_t
	
	private init(_ clockID: clockid_t) {
		self.clockID = clockID
	}
	
	/// Get the current time
	public func now() -> Time {
		var ts = timespec()
		clock_gettime(self.clockID, &ts)
		return Time(seconds: ts.tv_sec, nanoseconds: ts.tv_nsec)
	}
}
