import Foundation
/**
 * ***OrderedSet*** represents wrapper over Obj-C NSMutableOrderedSet.
 * *
 * NSMutableOrderedSet objects are not like C arrays. That is, even though you may specify a size when you create a mutable ordered set, the specified size is regarded as a “hint”; the actual size of the set is still 0. This means that you cannot insert an object at an index greater than the current count of an set. For example, if a set contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableOrderedSet raises an exception.
 *
 ** ***Application**:
 * - Search can be efficiently performed
  
 * ***Performance**:
 * - building the Ordered array is O(n)
 * - inserting is O(n)
 * - searching item is O(log n)
 *
 * **Drawback**:
 * - Since using dynamic array under the hood, contains all drawbacks of the dynamic array
 **/

public struct OrderedSet<T: Comparable & Hashable>: ExpressibleByArrayLiteral {
    @usableFromInline
    internal let _storage: NSMutableOrderedSet
    
    // MARK: - Initialization
    
    /**
     Description: *Initialization*
        init as empty OrderedSet
     */
    @inlinable
    public init() {
        _storage = NSMutableOrderedSet()
    }
    /**
     Description: *Initialization with capacity*
     - parameter capacity: capacity of element, that need to be allocated under NSMutableOrderedSet
     */
    @inlinable
    public init(capacity: Int) {
        _storage = NSMutableOrderedSet(capacity: capacity)
    }
    
    /**
     Description: *Initialization with any Container conforming Collection protocol*
     - parameter collection: some container of items
     */
    @inlinable
    public init<CollectionType: Collection>(collection: CollectionType) where CollectionType.Element == T {
        self.init(capacity: collection.count)
        insert(collection)
    }
    
    /**
     Description: *Creates an instance initialized with the given elements*
     - parameter elements: given elements
     */
    @inlinable
    public init(arrayLiteral elements: T...) {
        self.init(collection: elements)
    }
    
    @inlinable
    public var count: Int {
        return _storage.count
    }
    
    /**
     Description: *Apply body closure to all objects*
     
     - parameter body: apply body closure to all element in collection as if run over loop for
     */
    @inlinable
    public func forEach(_ body: (T) -> Void) {
        _storage.forEach { body($0 as! T) }
    }
    
    /**
     Description: *Check if current element is contained in the NSMutableOrderedSet*
     - parameter element: element of the NSMutableOrderedSet
     - returns: true if current item is contained in the _storage, false otherwise
     */
    @inlinable
    public func contains(_ element: T) -> Bool {
        return _storage.contains(element)
    }
    
    @inlinable
    public subscript(index: Int) -> T {
        get {
            return _storage[index] as! T
        }
        set(newValue) {
            insert(newValue)
        }
    }
    
    /**
     Description: *Defines the order of NSMutableOrderedSet to be added*
     */
    @usableFromInline
    internal static func compare(_ a: Any, _ b: Any) -> ComparisonResult {
        let a = a as! T, b = b as! T
        if a < b { return .orderedAscending }
        if a > b { return .orderedDescending }
        return .orderedSame
    }
    
    /**
     Description: *Insert item from any Collection
     - parameter collection: any container. conformed Collection protocol (Set, Array)
     */
    @usableFromInline
    internal func insert<S: Sequence>(_ seq: S) where S.Element == T {
        for element in seq {
            insert(element)
        }
    }
}

// MARK: - LOOKUP ELEMENT

extension OrderedSet {
    /**
     Description: *Searching element by *element**
     - parameter element
     - returns: see **Result**
     **/
    @inlinable
    public func lookUp(of element: T) -> Result<Int> {
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

// MARK: - INSERTION ELEMENT

extension OrderedSet {
    /**
     Description: *Define index to be added to NSMutableOrderedSet*
     - parameter value: element to be added
     - returns: appropriate index of value to be added to keep ordered order
     */
    @usableFromInline
    internal func index(for value: T) -> Int {
        return _storage.index(of: value,
                              inSortedRange: NSRange(0 ..< _storage.count),
                              options: .insertionIndex,
                              usingComparator: OrderedSet.compare)
    }
    
    /**
       Description: find index of element, where element might be inserted and insert it, otherwise
       ignore element if there is such element, does nothing
       
       - parameter newElement: new element of NSMutableOrderedSet
       */
    @inlinable
    public func insert(_ newElement: T) {
        let index = self.index(for: newElement)
        if index < _storage.count, _storage[index] as! T == newElement { return }
        _storage.insert(newElement, at: index)
    }
}

// MARK: - REMOVE ELEMENT

extension OrderedSet {
    @inlinable
    public mutating func remove(obj: T) {
        _storage.remove(obj)
    }
    
    @inlinable
    public mutating func removeAll() {
        _storage.removeAllObjects()
    }
}

extension OrderedSet: Sequence {
    @inlinable
    public func makeIterator() -> NSFastEnumerationIterator {
        return _storage.makeIterator()
    }
}
