//
//  Deadline.swift
//  Time
//

import Dispatch

/// Represents a point in time relative to some fixed time in the past
public struct Deadline: Equatable, Hashable {
	public typealias Value = UInt64
	
	public static let always = Deadline(0)
	public static let never = Deadline(DispatchTime.distantFuture.uptimeNanoseconds)
	
	public let uptimeNanoseconds: Value
	
	private init(_ nanoseconds: Value) {
		self.uptimeNanoseconds = nanoseconds
	}
	
	public static func now() -> Deadline {
		return Deadline(DispatchTime.now().uptimeNanoseconds)
	}
	
	public static func uptimeNanoseconds(_ nanoseconds: Value) -> Deadline {
		return Deadline(nanoseconds)
	}
	
	@inlinable
	public var dispatchTime: DispatchTime {
		return DispatchTime(uptimeNanoseconds: self.uptimeNanoseconds)
	}
}

extension Deadline: Comparable {
	@inlinable
	public static func < (lhs: Deadline, rhs: Deadline) -> Bool {
		return lhs.uptimeNanoseconds < rhs.uptimeNanoseconds
	}
}

extension Deadline: CustomStringConvertible {
	@inlinable
	public var description: String {
		return self.uptimeNanoseconds.description
	}
}

extension Deadline {
	@inlinable
	public static func - (lhs: Deadline, rhs: Deadline) -> Timeout {
		return .nanoseconds(Timeout.Value(lhs.uptimeNanoseconds - rhs.uptimeNanoseconds))
	}
	
	@inlinable
	public static func + (lhs: Deadline, rhs: Timeout) -> Deadline {
		if rhs == .always { return .always }
		if rhs == .never { return .never}
		if rhs.nanoseconds < 0 {
			return .uptimeNanoseconds(lhs.uptimeNanoseconds - rhs.nanoseconds.magnitude)
		} else {
			return .uptimeNanoseconds(lhs.uptimeNanoseconds + rhs.nanoseconds.magnitude)
		}
	}
	
	@inlinable
	public static func - (lhs: Deadline, rhs: Timeout) -> Deadline {
		if rhs == .always { return .never }
		if rhs == .never { return .always}
		if rhs.nanoseconds < 0 {
			return .uptimeNanoseconds(lhs.uptimeNanoseconds + rhs.nanoseconds.magnitude)
		} else {
			return .uptimeNanoseconds(lhs.uptimeNanoseconds - rhs.nanoseconds.magnitude)
		}
	}
}
