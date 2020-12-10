public struct Heap<T> {
    
    /** The array that stores the heap's nodes. */
    @usableFromInline
    internal var nodes: ContiguousArray<T> = []
    
    /// Description: determines how to compare two nodes in the heap.
    /// Use '>' for a max-heap or '<' for a min-heap,
    /// or provide a comparing method if the heap is made
    /// of custom elements, for example tuples
    @usableFromInline
    internal var orderCriteria: (T, T) -> Bool
    
    /// Description: creates an empty heap.
    /// - Parameter sort: The sort function determines whether this is a min-heap or max-heap.
    /// For comparable data types, '>' makes a max-heap, '<' makes a min-heap.
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    /// Description: create a heap from an array. The order of the array does not matter;
    /// For comparable data types, '>' makes a max-heap, '<' makes a min-heap.
    /// - Parameters:
    ///   - array: array of elements
    ///   - sort:  The sort function determines whether this is a min-heap or max-heap.
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    /// Description: Configures the max-heap or min-heap from an array, in a bottom-up manner.
    /// Performance: This runs pretty much in O(n).
    /// - Parameter array: array of elements
    @usableFromInline
    internal mutating func configureHeap(from array: [T]) {
        nodes = ContiguousArray(array)
        for i in stride(from: (nodes.count/2-1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    @inlinable
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    @inlinable
    public var count: Int {
        return nodes.count
    }

    /// Description: returns the index of the parent of the element at index i.
    /// The element at index 0 is the root of the tree and has no parent.
    /// - Parameter i: current index of element
    @usableFromInline
    internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    /// Description: returns the index of the left child of the element at index i.
    /// Note that this index can be greater than the heap size, in which case
    /// there is no left child.
    /// - Parameter i: current index of element
    @usableFromInline
    internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 1
    }
    
    /// Description: returns the index of the right child of the element at index i.
    /// Note that this index can be greater than the heap size, in which case there is no right child.
    /// - Parameter i: current index of element
    @usableFromInline
    internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    
    /// Description: returns the maximum value in the heap (for a max-heap) or the minimum value (for a min-heap).
    @inlinable
    public func peek() -> T? {
        return nodes.first
    }
    
    /// Description: adds a new value to the heap. This reorders the heap so that the max-heap
    /// or min-heap property still holds. Performance: O(log n).
    /// - Parameter value: The element to append to the collection.
    @inlinable
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    /// Description: adds a sequence of values to the heap. This reorders the heap so that
    /// the max-heap or min-heap property still holds. Performance: O(log n).
    /// - Parameter sequence: The collection to insert to the heap.
    @inlinable
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    /// Description: allows you to change an element. This reorders the heap so that
    /// the max-heap or min-heap property still holds.
    /// - Parameters:
    ///   - i: index to replace
    ///   - value: replaced element
    @inlinable
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else { return }
        
        remove(at: i)
        insert(value)
    }
    
    /// Description: removes the root node from the heap. For a max-heap, this is the maximum value;
    /// for a min-heap it is the minimum value. Performance: O(log n).
    @inlinable
    @discardableResult
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    
    /// Description: removes an arbitrary node from the heap. Performance: O(log n).
    /// Note that you need to know the node's index.
    /// - Parameter index: index of element to remove
    @inlinable
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    
    /// Description: takes a child node and looks at its parents; if a parent is not larger
    /// (max-heap) or not smaller (min-heap) than the child, we exchange them.
    /// - Parameter index: current index
    @usableFromInline
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        nodes[childIndex] = child
    }
    
    /// Description: looks at a parent node and makes sure it is still larger (max-heap) or smaller (min-heap) than its children.
    /// - Parameters:
    ///   - index: left bounded  index
    ///   - endIndex: right bounded  index
    @usableFromInline
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        // Figure out which comes first if we order them by the sort function:
        // the parent, the left child, or the right child. If the parent comes
        // first, we're done. If not, that element is out-of-place and we make
        // it "float down" the tree until the heap property is restored.
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    @usableFromInline
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
}

// MARK: - Searching

extension Heap where T: Equatable {
    
    /// Description: get the index of a node in the heap. return nil if not found
    /// Performance: O(n)
    /// - Parameter node: current element to find index
    @inlinable
    public func index(of node: T) -> Int? {
        return nodes.firstIndex(where: { $0 == node })
    }
    
    /// Description: removes the first occurrence of a node from the heap. Remove nil if not found.
    /// Performance: O(n).
    /// - Parameter node: current element to remove
    @inlinable
    @discardableResult
    public mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
            return remove(at: index)
        }
        return nil
    }
    
}
