import Foundation

public struct Stack<T> {
    
    @usableFromInline
    internal var _storage: ContiguousArray<T>
    
    @inlinable
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    @inlinable
    public var count: Int {
        return _storage.count
    }
    
    @inlinable
    public mutating func push(_ element: T) {
        _storage.append(element)
    }
    
    @inlinable
    public mutating func pop() -> T? {
        return _storage.popLast()
    }
    
    @inlinable
    public var top: T? {
        return _storage.last
    }
    
    public init() {
        _storage = []
    }
}
