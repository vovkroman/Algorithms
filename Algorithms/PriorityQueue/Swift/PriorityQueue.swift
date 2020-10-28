/*
 Priority Queue, a queue where the most "important" items are at the front of
 the queue.
 
 The heap is a natural data structure for a priority queue, so this object
 simply wraps the Heap struct.
 
 All operations are O(log(*n*)).
 
 Just like a heap can be a max-heap or min-heap, the queue can be a max-priority
 queue (largest element first) or a min-priority queue (smallest element first).
 */

public struct PriorityQueue<T> {
    
    private var _heap: Heap<T>
    
    /*
     To create a max-priority queue, supply a > sort function. For a min-priority
     queue, use <.
     */
    public init(sort: @escaping (T, T) -> Bool) {
        _heap = Heap(sort: sort)
    }
    
    public var isEmpty: Bool {
        return _heap.isEmpty
    }
    
    public var count: Int {
        return _heap.count
    }
    
    public func peek() -> T? {
        return _heap.peek()
    }
    
    public mutating func enqueue(_ element: T) {
        _heap.insert(element)
    }
    
    public mutating func dequeue() -> T? {
        return _heap.remove()
    }
    
    /*
     Allows you to change the priority of an element. In a max-priority queue,
     the new priority should be larger than the old one; in a min-priority queue
     it should be smaller.
     */
    public mutating func changePriority(index i: Int, value: T) {
        return _heap.replace(index: i, value: value)
    }
}

extension PriorityQueue where T: Equatable {
    public func index(of element: T) -> Int? {
        return _heap.index(of: element)
    }
}