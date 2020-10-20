import Foundation

public struct Stack<T> {
    
    private var _storage: ContiguousArray<T> = []
    
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    public var count: Int {
        return _storage.count
    }
    
    public mutating func push(_ element: T) {
        _storage.append(element)
    }
    
    public mutating func pop() -> T? {
        return _storage.popLast()
    }
    
    public var top: T? {
        return _storage.last
    }
}
