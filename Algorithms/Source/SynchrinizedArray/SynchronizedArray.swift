import Foundation

/** **Thread-safe array**: is a array which implemnting additional logic tied to thread safe access to element of array
 
**Application**
 - Can be efficient on concurrent task
 
**Performance**:
 - has the same complexity as [Array](https://developer.apple.com/documentation/swift/array)*/
public class SynchronizedArray<Element> {
    @usableFromInline
    
    let queue = DispatchQueue(label: "io.algorithms.syncArray", attributes: .concurrent)
    @usableFromInline
    var _storage: ContiguousArray<Element> = []
    
    @usableFromInline
    init() {}
    
    @inlinable
    public convenience init(_ array: [Element]) {
        self.init()
        self._storage = ContiguousArray(array)
    }
}

// MARK: - Properties
public extension SynchronizedArray {
    
    /// The first element of the collection.
    @inlinable
    var first: Element? {
        var result: Element?
        queue.sync { result = self._storage.first }
        return result
    }
    
    /// The last element of the collection.
    @inlinable
    var last: Element? {
        var result: Element?
        queue.sync { result = self._storage.last }
        return result
    }
    
    /// The number of elements in the array.
    @inlinable
    var count: Int {
        var result = 0
        queue.sync { result = self._storage.count }
        return result
    }
    
    /// A Boolean value indicating whether the collection is empty.
    @inlinable
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self._storage.isEmpty }
        return result
    }
    
    /// A textual representation of the array and its elements.
    @inlinable
    var description: String {
        var result = ""
        queue.sync { result = self._storage.description }
        return result
    }
}

// MARK: - Immutable
public extension SynchronizedArray {
    
    /// Description: returns the first element of the sequence that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and
    /// returns a Boolean value indicating whether the element is a match.
    @inlinable
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self._storage.first(where: predicate) }
        return result
    }
    
    /// Description: returns the last element of the sequence that satisfies the given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and
    /// returns a Boolean value indicating whether the element is a match.
    @inlinable
    func last(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self._storage.last(where: predicate) }
        return result
    }
    
    /// Description: returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and
    /// returns a Boolean value indicating whether the element should be included in the returned array.
    @inlinable
    func filter(_ isIncluded: @escaping (Element) -> Bool) -> SynchronizedArray {
        var result: SynchronizedArray?
        queue.sync { result = SynchronizedArray(self._storage.filter(isIncluded)) }
        return result!
    }
    
    /// Description: returns the first index in which an element of the collection satisfies the given predicate.
    /// - Parameter predicate: A closure that takes an element as its argument and
    /// returns a Boolean value that indicates whether the passed element represents a match.
    @inlinable
    func index(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        queue.sync { result = self._storage.firstIndex(where: predicate) }
        return result
    }
    
    /// Description: returns the elements of the collection,
    /// sorted using the given predicate as the comparison between elements.
    /// - Parameter areInIncreasingOrder: A predicate that returns true
    ///  if its first argument should be ordered before its second argument;
    ///  otherwise, false.
    @inlinable
    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> SynchronizedArray {
        var result: SynchronizedArray?
        queue.sync { result = SynchronizedArray(self._storage.sorted(by: areInIncreasingOrder)) }
        return result!
    }
    
    /// Description: returns an array containing the results of mapping the given closure over the sequence’s elements.
    /// - Parameter transform: A closure that accepts an element of this sequence
    /// as its argument and returns an optional value.
    @inlinable
    func map<ElementOfResult>(_ transform: @escaping (Element) -> ElementOfResult) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self._storage.map(transform) }
        return result
    }
    
    /// Description: returns an array containing the non-nil results of calling
    /// the given transformation with each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and
    /// returns an optional value.
    @inlinable
    func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self._storage.compactMap(transform) }
        return result
    }
    
    /// Description: returns the result of combining the elements of the sequence using the given closure.
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value. initialResult is passed to nextPartialResult the first time the closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and an element of the sequence into a new accumulating value, to be used in the next call of the nextPartialResult closure or returned to the caller.
    @inlinable
    func reduce<ElementOfResult>(_ initialResult: ElementOfResult, _ nextPartialResult: @escaping (ElementOfResult, Element) -> ElementOfResult) -> ElementOfResult {
        var result: ElementOfResult?
        queue.sync { result = self._storage.reduce(initialResult, nextPartialResult) }
        return result ?? initialResult
    }
    
    /// Description: returns the result of combining the elements of the sequence using the given closure.
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating value with an element of the sequence.
    @inlinable
    func reduce<ElementOfResult>(into initialResult: ElementOfResult, _ updateAccumulatingResult: @escaping (inout ElementOfResult, Element) -> ()) -> ElementOfResult {
        var result: ElementOfResult?
        queue.sync { result = self._storage.reduce(into: initialResult, updateAccumulatingResult) }
        return result ?? initialResult
    }
    
    /// Description: calls the given closure on each element in the sequence in the same order as a for-in loop.
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    @inlinable
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self._storage.forEach(body) }
    }
    
    /// Description: returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence
    /// as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    @inlinable
    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self._storage.contains(where: predicate) }
        return result
    }
    
    /// Description: returns a Boolean value indicating whether every element of a sequence satisfies a given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and
    ///  returns a Boolean value that indicates whether the passed element satisfies a condition.
    @inlinable
    func allSatisfy(_ predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self._storage.allSatisfy(predicate) }
        return result
    }
}

// MARK: - Mutable

public extension SynchronizedArray {
    
    /// Description: adds a new element at the end of the array.
    /// - Parameter element: The element to append to the array.
    @inlinable
    func append(_ element: Element) {
        queue.async(flags: .barrier) {
            self._storage.append(element)
        }
    }
    
    /// Description: adds new elements at the end of the array.
    ///
    /// - Parameter element: The elements to append to the array.
    @inlinable
    func append(_ elements: [Element]) {
        queue.async(flags: .barrier) {
            self._storage += elements
        }
    }
    
    /// Description: inserts a new element at the specified position.
    /// - Parameters:
    ///   - element: The new element to insert into the array.
    ///   - index: The position at which to insert the new element.
    @inlinable
    func insert(_ element: Element, at index: Int) {
        queue.async(flags: .barrier) {
            self._storage.insert(element, at: index)
        }
    }
    
    /// Description: removes and returns the element at the specified position.
    /// - Parameters:
    ///   - index: The position of the element to remove.
    ///   - completion: The handler with the removed element.
    @inlinable
    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self._storage.remove(at: index)
            DispatchQueue.main.async { completion?(element) }
        }
    }
    
    /// Description: removes and returns the elements that meet the criteria.
    /// - Parameters:
    ///   - predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    ///   - completion: The handler with the removed elements.
    @inlinable
    func remove(where predicate: @escaping (Element) -> Bool, completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            var elements = [Element]()
            
            while let index = self._storage.firstIndex(where: predicate) {
                elements.append(self._storage.remove(at: index))
            }
            
            DispatchQueue.main.async { completion?(elements) }
        }
    }
    
    /// Description: removes all elements from the array.
    /// - Parameter completion: The handler with the removed elements.
    @inlinable
    func removeAll(completion: ((ContiguousArray<Element>) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self._storage
            self._storage.removeAll()
            DispatchQueue.main.async { completion?(elements) }
        }
    }
}

public extension SynchronizedArray {
    
    /// Description: accesses the element at the specified position if it exists.
    /// - Parameter index: The position of the element to access.
    @inlinable
    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            
            queue.sync {
                guard self._storage.startIndex..<self._storage.endIndex ~= index else { return }
                result = self._storage[index]
            }
            
            return result
        }
        set {
            guard let newValue = newValue else { return }
            
            queue.async(flags: .barrier) {
                self._storage[index] = newValue
            }
        }
    }
}

// MARK: - Equatable
public extension SynchronizedArray where Element: Equatable {
    
    /// Description: returns a Boolean value indicating whether the sequence contains the given element.
    /// - Parameter element: The element to find in the sequence.
    @inlinable
    func contains(_ element: Element) -> Bool {
        var result = false
        queue.sync { result = self._storage.contains(element) }
        return result
    }
}

// MARK: - Infix operators
public extension SynchronizedArray {
    
    /// Description: adds a new element at the end of the array.
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The element to append to the array.
    @inlinable
    static func +=(left: inout SynchronizedArray, right: Element) {
        left.append(right)
    }
    
    /// Description: adds new elements at the end of the array.
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The elements to append to the array.
    @inlinable
    static func +=(left: inout SynchronizedArray, right: [Element]) {
        left.append(right)
    }
}
