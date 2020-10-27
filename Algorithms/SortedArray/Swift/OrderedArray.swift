/// Description
/**
* An ordered array represents wrapper around array with unique element.
* When you add a new item to this array, it is inserted in
* sorted position and checked if array contains such element by comparable key
**/
import Foundation

/**
 Description: *Result* represents result
 on searching element in ordered array
 
 Available cases:
 - **success(index:**: element contains in ordered array by index
 - **failure**: element doesn't contain in ordered array
 */
public enum Result {
    case success(index: Int) // element does contain in the array
    case failure // element doesn't contain in the array
}

extension Result: Equatable {}
public func ==(lhs: Result, rhs: Result) -> Bool {
    switch (lhs, rhs) {
    case (.success(let lhs), .success(let rhs)):
        return lhs == rhs
    case (.success(_), .failure), (.failure, .success(_)):
        return false
    case (.failure, .failure):
        return true
    }
}

public struct OrderedArray<T: Keyable> {
    
    public typealias ComparatorType = (T, T) -> Bool
    
    private var _storage: ContiguousArray<T>
    
    /**
     Description: *Initialization*
     
     - parameter array:      initialize with array (Default: [])
     - parameter comparator: Defines the signature how comparison operations is used. (Default: { $0.key < $1.key })
     */
    public init(array: [T] = [], comparator:  ComparatorType = { $0.key < $1.key })  {
        self._storage = ContiguousArray<T>(array.sorted(by: comparator))
    }
    
    public var isEmpty: Bool {
        return _storage.isEmpty
    }
    
    public var count: Int {
        return _storage.count
    }
    
    public subscript(index: Int) -> T {
        return _storage[index]
    }
    
    @discardableResult
    public mutating func removeAtIndex(index: Int) -> T {
        return _storage.remove(at: index)
    }
    
    public mutating func removeAll() {
        _storage.removeAll()
    }
    
    /**
     Description: *Insertion*: find index of element, where element might be inserted and insert it, otherwise
     ignore element if there is such element (performed by O(**log(n)**), but since used array under the hood, array can be reallocate additional capacity, and so summarize operation is performed by O(**n**)
     
     - parameter newElement: new element of array
     */
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
    
    /**
     Description: *Searching element by *key*
     
     - parameter key:
     
     - returns: see **Result**
     */
    public func lookUp<T: Comparable>(of key: T) -> Result where Element.KeyType == T {
        let index = findInsertionPoint(by: key)
        if index >= 0, index < _storage.count, _storage[index].key == key {
            return .success(index: index)
        } else {
            return .failure
        }
    }
    
    /**
     Description: Find convenient index of element by key,
     *     if element doesn't contains return startIndex or endIndex
     
     - parameter key: key
     
     - returns: index of element by key
     */
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

    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return _storage.makeIterator()
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return _storage.description
    }
}
