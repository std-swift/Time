//
//  TimeTests.swift
//  TimeTests
//

import XCTest
import Time

final class TimeTests: XCTestCase {
	func testIntegerConversion() {
		XCTAssertEqual(Time(10), Time(seconds: 10, nanoseconds: 0))
		XCTAssertEqual(Time(5), Time(seconds: 5, nanoseconds: 0))
	}
	
	func testDoubleConversion() {
		XCTAssertEqual(Time(10.0), Time(seconds: 10, nanoseconds: 0))
		XCTAssertEqual(Time(5.5), Time(seconds: 5, nanoseconds: 500_000_000))
	}
	
	func testStringConversion() {
		XCTAssertNil(Time("0.123456789123"))
		XCTAssertEqual(Time("0.1")!.description, "0.100000000")
		XCTAssertEqual(Time(1_000_000).description, "1000000.000000000")
	}
	
	func testView() {
		let time = Time(seconds: 12, nanoseconds: 3456789)
		XCTAssertEqual(time.seconds, 12)
		XCTAssertEqual(time.nanoseconds, 003_456_789)
		XCTAssertEqual(time.view.seconds, 12)
		XCTAssertEqual(time.view.milliseconds, 12_003)
		XCTAssertEqual(time.view.microseconds, 12_003_456)
		XCTAssertEqual(time.view.nanoseconds, 12_003_456_789)
	}
	
	func testDistantPast() {
		XCTAssertEqual(Time.distantPast.seconds, 0)
		XCTAssertEqual(Time.distantPast.nanoseconds, 0)
		XCTAssertEqual(Time.distantPast.view.seconds, 0)
		XCTAssertEqual(Time.distantPast.view.milliseconds, 0)
		XCTAssertEqual(Time.distantPast.view.microseconds, 0)
		XCTAssertEqual(Time.distantPast.view.nanoseconds, 0)
	}
	
	func testDistantFuture() {
		XCTAssertEqual(Time.distantFuture.seconds, .max)
		XCTAssertEqual(Time.distantFuture.nanoseconds, 0)
		XCTAssertEqual(Time.distantFuture.view.seconds, .max)
		XCTAssertEqual(Time.distantFuture.view.milliseconds, .max)
		XCTAssertEqual(Time.distantFuture.view.microseconds, .max)
		XCTAssertEqual(Time.distantFuture.view.nanoseconds, .max)
	}
	
	func testTimeoutArithmetic() {
		let base = Time(seconds: 10, nanoseconds: 5)
		let time1 = base + .nanoseconds(10)
		XCTAssertEqual(time1.view.nanoseconds, 10_000_000_015)
		let time2 = base - .nanoseconds(10)
		XCTAssertEqual(time2.view.nanoseconds, 09_999_999_995)
		let time3 = base + .nanoseconds(1_999_999_999)
		XCTAssertEqual(time3.view.nanoseconds, 12_000_000_004)
		let time4 = base - .nanoseconds(1_999_999_999)
		XCTAssertEqual(time4.view.nanoseconds, 08_000_000_006)
		
		let time5 = base - .nanoseconds(-10)
		XCTAssertEqual(time5.view.nanoseconds, 10_000_000_015)
		let time6 = base + .nanoseconds(-10)
		XCTAssertEqual(time6.view.nanoseconds, 09_999_999_995)
		let time7 = base - .nanoseconds(-1_999_999_999)
		XCTAssertEqual(time7.view.nanoseconds, 12_000_000_004)
		let time8 = base + .nanoseconds(-1_999_999_999)
		XCTAssertEqual(time8.view.nanoseconds, 08_000_000_006)
	}
}
