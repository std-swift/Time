//
//  Timeout.swift
//  Time
//
import Dispatch
/// Represents a time interval in nanoseconds
public struct Timeout: Equatable {
	public typealias Value = Int64
	
	public static let always = Timeout(.min)
	public static let never = Timeout(.max)
	
	public let nanoseconds: Value
	
	private init(_ nanoseconds: Value) {
		self.nanoseconds = nanoseconds
	}
	
	public static func nanoseconds(_ amount: Value) -> Timeout {
		return Timeout(amount)
	}
	
	public static func microseconds(_ amount: Value) -> Timeout {
		return Timeout(amount * 1_000)
	}
	
	public static func milliseconds(_ amount: Value) -> Timeout {
		return Timeout(amount * 1_000_000)
	}
	
	public static func seconds(_ amount: Value) -> Timeout {
		return Timeout(amount * 1_000_000_000)
	}
	
	public static func minutes(_ amount: Value) -> Timeout {
		return Timeout(amount * 60_000_000_000)
	}
	
	public static func hours(_ amount: Value) -> Timeout {
		return Timeout(amount * 3_600_000_000_000)
	}
}

extension Timeout: Comparable {
	@inlinable
	public static func < (lhs: Timeout, rhs: Timeout) -> Bool {
		return lhs.nanoseconds < rhs.nanoseconds
	}
}

extension Timeout {
	public static func + (lhs: Timeout, rhs: Timeout) -> Timeout {
		return Timeout(lhs.nanoseconds + rhs.nanoseconds)
	}
	
	public static func - (lhs: Timeout, rhs: Timeout) -> Timeout {
		return Timeout(lhs.nanoseconds - rhs.nanoseconds)
	}
	
	public static func * <T: BinaryInteger>(lhs: T, rhs: Timeout) -> Timeout {
		return Timeout(Timeout.Value(lhs) * rhs.nanoseconds)
	}
	
	public static func * <T: BinaryInteger>(lhs: Timeout, rhs: T) -> Timeout {
		return Timeout(lhs.nanoseconds * Timeout.Value(rhs))
	}
}
