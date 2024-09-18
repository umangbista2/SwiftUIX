//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

/// A `Binding` that only allows the _setting_ of values.
@frozen
@propertyWrapper
@_documentation(visibility: internal)
public struct SetBinding<Value: Sendable> : Sendable {
    @usableFromInline
    let set: @Sendable (Value) -> ()
    
    @inlinable
    public init(set: @Sendable @escaping (Value) -> ()) {
        self.set = set
    }
    
    @inlinable
    public init(_ binding: Binding<Value>) {
        self.set = { @Sendable in binding.wrappedValue = $0 }
    }
    
    @inlinable
    public var wrappedValue: Value {
        get {
            fatalError()
        } nonmutating set {
            set(newValue)
        }
    }
    
    @inlinable
    public var projectedValue: Binding<Value> {
        .init(
            get: { fatalError() },
            set: { set($0) }
        )
    }
    
    @inlinable
    public func set(_ value: Value) {
        self.set(value)
    }
}

// MARK: - Helpers

extension Binding {
    @inlinable
    public init(set: SetBinding<Value>, defaultValue: Value) where Value: Sendable {
        self.init(
            get: { defaultValue },
            set: { set.set($0) }
        )
    }
}
