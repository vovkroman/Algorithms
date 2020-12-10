import Foundation

public struct Queue<T> {
    
    @usableFromInline
    internal var _storage: ContiguousArray<T>
    
    @inlinable
    public var count: Int {
        return _storage.count
    }
    
    @inlinable
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    @inlinable
    public mutating func enqueue(_ element: T) {
        _storage.append(element)
    }
    
    @inlinable
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return _storage.removeFirst()
        }
    }
    
    @inlinable
    public var front: T? {
        return _storage.first
    }
    
    public init() {
        _storage = []
    }
}

extension Queue: Sequence {
    @inlinable
    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return _storage.makeIterator()
    }
}
