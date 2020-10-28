import Foundation
/**
 * OrderedSet represents wrapper over Obj-C NSMutableOrderedSet.
 *
 *
 * NSMutableOrderedSet objects are not like C arrays. That is, even though you may specify a size when you create a mutable ordered set, the specified size is regarded as a “hint”; the actual size of the set is still 0. This means that you cannot insert an object at an index greater than the current count of an set. For example, if a set contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableOrderedSet raises an exception.,
 **/

public struct OrderedSet<T: Comparable & Hashable>: ExpressibleByArrayLiteral {
    private let _storage: NSMutableOrderedSet
    
    // MARK: - Initialization
    
    /**
     Description: *Initialization*
        init as empty OrderedSet
     */
    public init() {
        _storage = NSMutableOrderedSet()
    }
    /**
     Description: *Initialization with capacity*
     - parameter capacity: capacity of element, that need to be allocated under NSMutableOrderedSet
     */
    public init(capacity: Int) {
        _storage = NSMutableOrderedSet(capacity: capacity)
    }
    
    /**
     Description: *Initialization with any Container conforming Collection protocol*
     - parameter collection: some container of items
     */
    public init<CollectionType: Collection>(collection: CollectionType) where CollectionType.Element == T {
        self.init(capacity: collection.count)
        insert(collection)
    }
    
    
    /**
     Description: *Creates an instance initialized with the given elements*
     - parameter elements: given elements
     */
    public init(arrayLiteral elements: T...) {
        self.init(collection: elements)
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
    
    /**
     Description: *Check if current element is contained in the NSMutableOrderedSet*
     - parameter element: element of the NSMutableOrderedSet
     - returns: true if current item is contained in the _storage, false otherwise
     */
    public func contains(_ element: T) -> Bool {
        return _storage.contains(element)
    }
    
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
    private static func compare(_ a: Any, _ b: Any) -> ComparisonResult {
        let a = a as! T, b = b as! T
        if a < b { return .orderedAscending }
        if a > b { return .orderedDescending }
        return .orderedSame
    }
    
    /**
     Description: *Insert item from any Collection
     - parameter collection: any container. conformed Collection protocol (Set, Array)
     */
    private func insert<CollectionType: Collection>(_ collection: CollectionType) where CollectionType.Element == T {
        for element in collection {
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

// MARK: - INSERTION ELEMENT

extension OrderedSet {
    /**
     Description: *Define index to be added to NSMutableOrderedSet*
     - parameter value: element to be added
     - returns: appropriate index of value to be added to keep ordered order
     */
    private func index(for value: T) -> Int {
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
    public func insert(_ newElement: T) {
        let index = self.index(for: newElement)
        if index < _storage.count, _storage[index] as! T == newElement { return }
        _storage.insert(newElement, at: index)
    }
}

// MARK: - REMOVE ELEMENT

extension OrderedSet {
    public mutating func remove(obj: T) {
        _storage.remove(obj)
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
