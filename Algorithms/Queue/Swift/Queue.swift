//
//  Queue.swift
//  Algorithms
//
//  Created by Roman Vovk on 14.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import Foundation

public struct Queue<T> {
    private var _storage: ContiguousArray<T> = []
    
    public var count: Int {
        return _storage.count
    }
    
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        _storage.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return _storage.removeFirst()
        }
    }
    
    public var front: T? {
        return _storage.first
    }
}
