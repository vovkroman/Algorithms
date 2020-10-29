import Foundation

// Raw implementation of Single Linked list
public enum LinkedList<Element> {
    case end
    indirect case node(Element, next: LinkedList<Element>)
}

extension LinkedList {
    /// Return a new list by prepending a node with value `x` to the
    /// front of a list.
    @usableFromInline
    internal func cons(_ x: Element) -> Self {
        return .node(x, next: self)
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    @inlinable
    public init() {
        self = .end
    }
    
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
    
    @inlinable
    public mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
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
    
    @inlinable
    public mutating func next() -> Element? {
        return pop()
    }
}

extension LinkedList: CustomStringConvertible {
    
    private func diagram() -> String {
        let list = reduce("end") { $0 + "<-\($1)" }
        return list
    }
    
    public var description: String {
        return diagram()
    }
}
