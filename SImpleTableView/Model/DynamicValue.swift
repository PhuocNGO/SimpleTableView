//
//  DynamicValue.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/20/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class DynamicValue<T> {
    typealias Listener = ((T) -> Void)
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: Listener]()
    
    init(_ v: T) {
        self.value = v
    }
    
    public func addObserver(_ observer: NSObject, listener: Listener?) {
        observers[observer.description] = listener
    }
    
    public func addObserverAndFire(_ observer: NSObject, listener: Listener?) {
        self.addObserver(observer, listener: listener)
        self.notify()
    }
    
    private func notify() {
        observers.forEach( { $0.value(value ) } )
    }
    
    deinit {
        observers.removeAll()
    }
}
