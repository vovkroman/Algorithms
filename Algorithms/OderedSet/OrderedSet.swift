import Foundation
/**
 * OderedSet represent warpper around Obj-C NSMutableOrderedSet.
 *
 *
 * NSMutableOrderedSet objects are not like C arrays. That is, even though you may specify a size when you create a mutable ordered set, the specified size is regarded as a “hint”; the actual size of the set is still 0. This means that you cannot insert an object at an index greater than the current count of an set. For example, if a set contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableOrderedSet raises an exception.,
 **/

public struct OrderedSet<T: Comparable & Hashable> {
    let _storage: NSMutableOrderedSet
    
    // MARK: - Initialziation
    
    /**
     Description: *Intialization*
        init as empty OrderedSet
     */
    public init() {
        _storage = NSMutableOrderedSet()
    }
    /**
     Description: *Intialization with capacity*
     - parameter capacity: capacity of element, that need to be allocated under NSMutableOrderedSet
     */
    public init(capacity: Int) {
        _storage = NSMutableOrderedSet(capacity: capacity)
    }
    
    /**
     Description: *Intialization with set of objects*
     - parameter objects: some container of items
     */
    public init(objects: T...) {
        _storage = NSMutableOrderedSet(objects: objects)
    }
    
    public var count: Int {
        return _storage.count
    }
    
    /**
     Description: *Apply body closure to all objects*
     
     - parameter body: apply body closure to all element in collection as if run over loop for
     */
    public func forEach(_ body: (T) -> Void) {
        _storage.forEach { body($0 as! T) }
    }
    
    public func contains(_ element: T) -> Bool {
        return _storage.contains(element)
    }
    
    private static func compare(_ a: Any, _ b: Any) -> ComparisonResult {
        let a = a as! T, b = b as! T
        if a < b { return .orderedAscending }
        if a > b { return .orderedDescending }
        return .orderedSame
    }
}

// MARK: - LOOKUP ELEMENT

extension OrderedSet {
    public func lookUp(of element: T) -> Result {
        let index = _storage.index(of: element,
                                   inSortedRange: NSRange(0 ..< _storage.count),
                                   usingComparator: OrderedSet.compare)
        if index == NSNotFound {
            return .failure
        } else {
            return .success(index: index)
        }
    }
}

// MARK: - Insertion elements

extension OrderedSet {
    
    private func index(for value: T) -> Int {
        return _storage.index(of: value,
                              inSortedRange: NSRange(0 ..< _storage.count),
                              options: .insertionIndex,
                              usingComparator: OrderedSet.compare)
    }
    
    public func insert(_ newElement: T) {
        let index = self.index(for: newElement)
        if index < _storage.count, _storage[index] as! T == newElement { return }
        _storage.insert(newElement, at: index)
    }
}

// MARK: - Removing element

extension OrderedSet {
    public mutating func removeAtIndex(index: Int) {
        _storage.remove(index)
    }
    
    public mutating func removeAll() {
        _storage.removeAllObjects()
    }
}

extension OrderedSet: Sequence {
    
    public func makeIterator() -> NSFastEnumerationIterator {
        return _storage.makeIterator()
    }
}
