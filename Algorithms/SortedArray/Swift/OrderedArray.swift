/**
 * An ordered array represets wrapper arround array with unique element.
 * When you add a new item to this array, it is inserted in
 * sorted position and checked if array contains such element by comparable key
 **/
import Foundation

public enum Result {
    case success(index: Int) // element does contain in the array
    case failure // element doesn't contain in the array
}

public struct OrderedArray<T: Keyable> {
    
    public typealias ComparatorType = (T, T) -> Bool
    
    private var _storage: ContiguousArray<T>
    
    public init(array: [T] = [], comparator:  ComparatorType = { $0.key < $1.key })  {
        self._storage = ContiguousArray<T>(array.sorted(by: comparator))
    }
    
    @inline(__always)
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    @inline(__always)
    public var count: Int {
        return _storage.count
    }
    
    @inline(__always)
    public subscript(index: Int) -> T {
        return _storage[index]
    }
    
    @inline(__always)
    public mutating func removeAtIndex(index: Int) -> T {
        return _storage.remove(at: index)
    }
    
    @inline(__always)
    public mutating func removeAll() {
        _storage.removeAll()
    }
    
    @inline(__always)
    public mutating func insert(newElement: T) {
        if _storage.isEmpty {
            _storage.append(newElement)
            return
        }
        let index = findInsertionPoint(by: newElement.key)
        if index >= 0, index < _storage.count, _storage[index].key == newElement.key { return }
        var insertIndex = index
        if _storage[index].key < newElement.key { insertIndex += 1 }
        _storage.insert(newElement, at: insertIndex)
    }
    
    @inline(__always)
    public func lookUp<T: Comparable>(of key: T) -> Result where Element.KeyType == T {
        let index = findInsertionPoint(by: key)
        if index >= 0, index < _storage.count, _storage[index].key == key {
            return .success(index: index)
        } else {
            return .failure
        }
    }
    
    /**
     *
     **/
    private func findInsertionPoint<T: Comparable>(by key: T) -> Int where Element.KeyType == T {
        var startIndex = 0
        var endIndex = _storage.count - 1
        
        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if _storage[midIndex].key == key {
                return midIndex
            } else if _storage[midIndex].key < key {
                startIndex = midIndex + 1
            } else {
                endIndex = midIndex
            }
        }
        return startIndex
    }
}

extension OrderedArray: Sequence {
    
    public typealias Element = T

    @inline(__always)
    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return _storage.makeIterator()
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return _storage.description
    }
}
