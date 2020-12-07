/****Priority Queue**: is a queue where the most "important" items are at the front of the queue. Just like a heap can be a max-heap or min-heap, the queue can be a max-priority queue (largest element first) or a min-priority queue (smallest element first).

* Current implementation is wrapper around [Heap](https://en.wikipedia.org/wiki/Heap_(data_structure))
 
**Application**:
 - Can be efficient on dynamically sorted problems
 
**Performance**:
 -  All operations are O(log(*n*)).
 */

public struct PriorityQueue<T> {
    
    @usableFromInline
    internal var _heap: Heap<T>
    
    /// Description: to create empty priority queue (max-priority queue (a > sort),
    /// or priority queue (a > sort))
    /// - Parameter sort: closure to define max or min priority queue
    @inlinable
    public init(sort: @escaping (T, T) -> Bool) {
        _heap = Heap(sort: sort)
    }
    
    /// Description: to create priority queue (max-priority queue (a > sort),
    /// - Parameters:
    ///   - array: array data to fill up priority queue;
    ///   - sort: closure to define max or min priority queue
    @inlinable
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        _heap = Heap(array: array, sort: sort)
    }
    
    @inlinable
    public var isEmpty: Bool {
        return _heap.isEmpty
    }
    
    @inlinable
    public var count: Int {
        return _heap.count
    }
    
    @inlinable
    public func peek() -> T? {
        return _heap.peek()
    }
    
    @inlinable
    public mutating func enqueue(_ element: T) {
        _heap.insert(element)
    }
    
    /// Description: Returns element in queue
    /// if current PriorityQueue is max, will return max element,
    /// min otherwise
    @inlinable
    public mutating func dequeue() -> T? {
        return _heap.remove()
    }
    
    /// Description: Allows you to change the priority of an element. In a max-priority queue,
    /// the new priority should be larger than the old one; in a min-priority queue
    /// it should be smaller.
    ///
    /// - Parameters:
    ///   - i: index of the element that needs to be changed
    ///   - value: changed value
    @inlinable
    public mutating func changePriority(index i: Int, value: T) {
        return _heap.replace(index: i, value: value)
    }
}

extension PriorityQueue: Sequence {
    public typealias Element = T
    
    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return _heap.nodes.makeIterator()
    }
}

extension PriorityQueue where T: Equatable {
    @inlinable
    ///Description: define index of the element
    /// - Parameter element: searching element
    /// - Returns: index of the element in heap
    public func index(of element: T) -> Int? {
        return _heap.index(of: element)
    }
}
