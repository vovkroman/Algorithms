/// Description
/**
* ***LinkedList*** is  a linear collection of data elements whose order is not given by their physical placement in memory. Instead, each element points to the next. (https://en.wikipedia.org/wiki/Linked_list).
* ***Application**:
* - LinkedList is commonly used as part of effiecent algorithms.
 
* ***Performance**:
* - build is O(n)
* - searching item is O(n)
* - iterating  item is O(n)
* - Inserting is O(1)
* - deleting  item is O(1)
**/
import Foundation

// Raw implementation of Single Linked list:
public enum LinkedList<Element> {
    case end
    indirect case node(Element, next: LinkedList<Element>)
}

extension LinkedList {
    /// Description: Create new LinkedList so, that a new list by prepending a node with value `x` to the
    /// front of a list.
    /// - Parameter x: new raw element
    /// - Returns: Return a new list by prepending a node with value `x` to the
    /// front of a list.
    @usableFromInline
    internal func cons(_ x: Element) -> Self {
        return .node(x, next: self)
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    
    /// init empty linked list
    @inlinable
    public init() {
        self = .end
    }
    
    /// Description: *Initialize* new linked list with given elements
    /// - Parameter elements: collection of items
    @inlinable
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    /**
     Description: *Initialization with any Container conforming Collection protocol*
     - parameter collection: some container of items
     */
    @inlinable
    public init<S: Sequence>(_ seq: S) where S.Iterator.Element == Element {
        var list: LinkedList = .end
        for element in seq {
            list = list.cons(element)
        }
        self = list
    }
}

extension LinkedList {
    
    /// Description: make self to point to front of list (head)
    ///
    /// - Parameter x: new raw element
    @inlinable
    public mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
    /// Description: pop last added item
    /// - Returns: return raw element
    @inlinable
    public mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(x, next: tail):
            self = tail
            return x
        }
    }
}

extension LinkedList: IteratorProtocol, Sequence {
    
    /// Description: iterate over the list by popping element from the list
    /// - Returns: return raw element
    @inlinable
    public mutating func next() -> Element? {
        return pop()
    }
}

extension LinkedList: CustomStringConvertible {
    
    /// Description: additional method to print list in reversed order
    /// - Returns: return concatenated string of values
    private func diagram() -> String {
        let list: [String] = compactMap{ "\($0)" }
        return list.reversed().joined(separator: "->")
    }
    
    public var description: String {
        return diagram()
    }
}
