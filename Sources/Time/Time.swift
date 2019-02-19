//
//  Time.swift
//  Time
//

/// Represents a time in terms of seconds and nanoseconds
public struct Time: Equatable, Hashable {
	public static var distantPast = Time(seconds: 0, nanoseconds: 0)
	public static var distantFuture = Time(seconds: .max, nanoseconds: 0)
	
	/// Provides a view of the time with different base units
	public struct View {
		private let time: Time
		
		fileprivate init(time: Time) {
			self.time = time
		}
		
		/// The total number of seconds that the `Time` represents
		public var seconds: Int {
			return self.time.seconds
		}
		
		/// The total number of milliseconds that the `Time` represents
		public var milliseconds: Int {
			let (product, overflow1) = self.time.seconds
				.multipliedReportingOverflow(by: 1_000)
			if overflow1 { return .max }
			let (sum, overflow2) = product
				.addingReportingOverflow(self.time.nanoseconds / 1_000_000)
			if overflow2 { return .max }
			return sum
		}
		
		/// The total number of microseconds that the `Time` represents
		public var microseconds: Int {
			let (product, overflow1) = self.time.seconds
				.multipliedReportingOverflow(by: 1_000_000)
			if overflow1 { return .max }
			let (sum, overflow2) = product
				.addingReportingOverflow(self.time.nanoseconds / 1_000)
			if overflow2 { return .max }
			return sum
		}
		
		/// The total number of nanoseconds that the `Time` represents
		public var nanoseconds: Int {
			let (product, overflow1) = self.time.seconds
				.multipliedReportingOverflow(by: 1_000_000_000)
			if overflow1 { return .max }
			let (sum, overflow2) = product
				.addingReportingOverflow(self.time.nanoseconds)
			if overflow2 { return .max }
			return sum
		}
	}
	
	/// The number of seconds
	public var seconds: Int
	/// The number of nanoseconds until the next second
	public var nanoseconds: Int
	
	/// Retreive a view of the time in different units
	public var view: View {
		return View(time: self)
	}
	
	/// - Precondition: `nanoseconds >= 0`
	/// - Precondition: `nanoseconds < 1_000_000_000`
	@inlinable
	public init(seconds: Int, nanoseconds: Int) {
		precondition(nanoseconds >= 0)
		precondition(nanoseconds < 1_000_000_000)
		self.seconds = seconds
		self.nanoseconds = nanoseconds
	}
}

extension Time: Comparable {
	@inlinable
	public static func < (lhs: Time, rhs: Time) -> Bool {
		if lhs.seconds < rhs.seconds { return true }
		return lhs.seconds == rhs.seconds && lhs.nanoseconds < rhs.nanoseconds
	}
}

extension Time: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Int) {
		self.seconds = value
		self.nanoseconds = 0
	}
}

extension Time: ExpressibleByFloatLiteral {
	public init(floatLiteral value: Double) {
		let fraction = value.truncatingRemainder(dividingBy: 1.0)
		self.seconds = Int(value)
		self.nanoseconds = Int(fraction * 1_000_000_000.0)
	}
}

extension Time: LosslessStringConvertible {
	public init?(_ description: String) {
		let parts = description.split(separator: ".")
		guard parts.count == 2 else { return nil }
		guard let seconds = Int(parts[0]) else { return nil }
		guard parts[1].count <= 9 else { return nil }
		let nano = parts[1] + String(repeating:"0", count: 9 - parts[1].count)
		guard let nanoseconds = Int(nano) else { return nil }
		self.seconds = seconds
		self.nanoseconds = nanoseconds
	}
	
	@inlinable
	public var description: String {
		let seconds = self.seconds.description
		let nanoseconds = self.nanoseconds.description
		let leadingNano = String(repeating: "0", count: 9 - nanoseconds.count)
		return seconds + "." + leadingNano + nanoseconds
	}
}

extension Time {
	@inlinable
	public static func - (lhs: Time, rhs: Time) -> Timeout {
		return .nanoseconds(Timeout.Value(lhs.view.nanoseconds - rhs.view.nanoseconds))
	}
	
	@inlinable
	public static func + (lhs: Time, rhs: Timeout) -> Time {
		if rhs == .always { return .distantPast }
		if rhs == .never { return .distantFuture }
		let (seconds, nanoseconds) = rhs.nanoseconds
			.quotientAndRemainder(dividingBy: 1_000_000_000)
		var (s, ns) = (lhs.nanoseconds + Int(nanoseconds))
			.quotientAndRemainder(dividingBy: 1_000_000_000)
		if ns < 0 {
			ns += 1_000_000_000
			s -= 1
		}
		return Time(seconds: lhs.seconds + s + Int(seconds), nanoseconds: ns)
	}
	
	@inlinable
	public static func - (lhs: Time, rhs: Timeout) -> Time {
		if rhs == .always { return .distantPast }
		if rhs == .never { return .distantFuture }
		let (seconds, nanoseconds) = rhs.nanoseconds
			.quotientAndRemainder(dividingBy: 1_000_000_000)
		var (s, ns) = (lhs.nanoseconds - Int(nanoseconds))
			.quotientAndRemainder(dividingBy: 1_000_000_000)
		if ns < 0 {
			ns += 1_000_000_000
			s -= 1
		}
		return Time(seconds: lhs.seconds + s - Int(seconds), nanoseconds: ns)
	}
}
