import Foundation

extension Result: Equatable where T == Int {}

@inlinable
public func ==(lhs: Result<Int>, rhs: Result<Int>) -> Bool {
    switch (lhs, rhs) {
    case (.success(let lhs), .success(let rhs)):
        return lhs == rhs
    case (.success(_), .failure), (.failure, .success(_)):
        return false
    case (.failure, .failure):
        return true
    }
}

/****Ordered array** represents wrapper around array with unique element.

When you add a new item to this array, it is inserted in sorted position and checked if array contains such element by comparable key

**Application**:
 - Search can be efficiently performed
 
**Performance**:
- building the Ordered array is O(n)
- inserting is O(n)
- searching item is O(log n)
 
**Drawback**:
- Since using dynamic array under the hood, contains all drawbacks of the dynamic array; */
public struct OrderedArray<T: Keyable> {
    
    public typealias ComparatorType = (T, T) -> Bool
    
    @usableFromInline
    internal var _storage: ContiguousArray<T>
    
    /// Description: Initialization with array
    /// - Parameters:
    ///   - array: array (Default: [])
    ///   - comparator: Defines the signature how comparison operations is used. (Default: { $0.key < $1.key })
    @inlinable
    public init(array: [T] = [], comparator:  ComparatorType = { $0.key < $1.key })  {
        self._storage = ContiguousArray<T>(array.sorted(by: comparator))
    }
    
    @inlinable
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    @inlinable
    public var count: Int {
        return _storage.count
    }
    
    @inlinable
    public subscript(index: Int) -> T {
        return _storage[index]
    }
    
    /// Description: removes element at specific index
    /// - Parameter index: index of element to remove
    @inlinable
    @discardableResult
    public mutating func removeAtIndex(index: Int) -> T {
        return _storage.remove(at: index)
    }
    
    @inlinable
    public mutating func removeAll() {
        _storage.removeAll()
    }
    
    /// Description: find index of element, where element might be inserted and insert it, otherwise
    /// ignore element if there is such element (performed by O(**log(n)**), but since used array under the hood,
    /// array can be reallocate additional capacity, and so summarized operation is performed by O(**n**)
    /// - Parameter newElement: new element to insert
    @inlinable
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
    
    /// Description: searching element by *key* and returns see. *Result*.
    /// - Parameter key: key to search element
    @inlinable
    public func lookUp<T: Comparable>(of key: T) -> Result<Int> where Element.KeyType == T {
        let index = findInsertionPoint(by: key)
        if index >= 0, index < _storage.count, _storage[index].key == key {
            return .success(index: index)
        } else {
            return .failure
        }
    }
    
    /// Description: Find convenient index of element by key,
    /// see [Binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm).
    ///
    /// - Parameter key (identifire of the element).
    @usableFromInline
    internal func findInsertionPoint<T: Comparable>(by key: T) -> Int where Element.KeyType == T {
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

    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return _storage.makeIterator()
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return _storage.description
    }
}
