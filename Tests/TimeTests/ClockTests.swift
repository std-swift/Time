//
//  ClockTests.swift
//  TimeTests
//

import XCTest
import Time

final class ClockTests: XCTestCase {
	func testRealtimeClock() {
		let clock = Clock.realtime
		let start = clock.now()
		print("Starting at: \(start)")
		XCTAssertGreaterThan(clock.now(), start)
	}
	
	func testMonotonicClock() {
		let clock = Clock.monotonic
		let start = clock.now()
		print("Starting at: \(start)")
		XCTAssertGreaterThan(clock.now(), start)
	}
	
	func testProcessClock() {
		let clock = Clock.process
		let start = clock.now()
		print("Starting at: \(start)")
		XCTAssertGreaterThan(clock.now(), start)
	}
	
	func testThreadClock() {
		let clock = Clock.thread
		let start = clock.now()
		print("Starting at: \(start)")
		XCTAssertGreaterThan(clock.now(), start)
	}
}
