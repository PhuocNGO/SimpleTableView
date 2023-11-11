//
//  DynamicValue.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/20/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// A generic data source class that holds a dynamic value of a generic type.
class GenericDataSource<T>: NSObject {
    /// Dynamic value that can be observed for changes.
    var data: DynamicValue<[T]> = DynamicValue([])
}

/// A generic class representing a dynamic value that can be observed for changes.
class DynamicValue<T> {
    /// A typealias for the closure that gets called when the value changes.
    typealias Listener = ((T) -> Void)
    
    /// The current value of the dynamic value.
    var value: T {
        didSet {
            notify()
        }
    }
    
    /// Dictionary to store observers using their descriptions.
    private var observers = [String: Listener]()
    
    /// Initializes a new instance of DynamicValue with an initial value.
    ///
    /// - Parameter v: The initial value.
    init(_ v: T) {
        self.value = v
    }
    
    /// Adds an observer to the dynamic value.
    ///
    /// - Parameters:
    ///   - observer: The observer object.
    ///   - listener: The closure to be called when the value changes.
    public func addObserver(_ observer: NSObject, listener: Listener?) {
        observers[observer.description] = listener
    }
    
    /// Adds an observer to the dynamic value and immediately calls the listener.
    ///
    /// - Parameters:
    ///   - observer: The observer object.
    ///   - listener: The closure to be called when the value changes.
    public func addObserverAndFire(_ observer: NSObject, listener: Listener?) {
        addObserver(observer, listener: listener)
        notify()
    }
    
    /// Notifies all observers about the change in value.
    private func notify() {
        observers.forEach { $0.value(value) }
    }
    
    /// Deinitializes the DynamicValue instance and removes all observers.
    deinit {
        observers.removeAll()
    }
}

