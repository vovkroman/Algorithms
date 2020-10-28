import Foundation

// Raw implementation of Single Linked list
public enum LinkedList<Element> {
    case end
    indirect case node(Element, next: LinkedList<Element>)
}

extension LinkedList {
    /// Return a new list by prepending a node with value `x` to the
    /// front of a list.
    private func cons(_ x: Element) -> Self {
        return .node(x, next: self)
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    
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
    public init<CollectionType: Collection>(_ collection: CollectionType) where CollectionType.Element == Element {
        var list: LinkedList = .end
        for element in collection {
            list = list.cons(element)
        }
        self = list
    }
}

extension LinkedList {
    
    public mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
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
/*** SingleLinkedList is wrapper around LinkedList,
 * and contains COW (Copy-on-write) semantic implemenation
 **/
public struct SingleLinkedList<Element> {
    private var _storage: Box<LinkedList<Element>>
}

extension SingleLinkedList: ExpressibleByArrayLiteral {
    
    public init() {
        _storage = Box(value: LinkedList())
    }
    
    public init(arrayLiteral elements: Element...) {
        let linkedList: LinkedList = LinkedList(elements)
        _storage = Box(value: linkedList)
    }
}

extension SingleLinkedList {
    
    public mutating func push(_ x: Element) {
        _storage.value.push(x)
    }
    
    public mutating func pop() -> Element? {
        return _storage.value.pop()
    }
}

extension SingleLinkedList: IteratorProtocol, Sequence {
    
    public mutating func next() -> Element? {
        return _storage.value.pop()
    }
}


extension SingleLinkedList: CustomStringConvertible {
    
    private func diagram() -> String {
        let description = _storage.value.reduce("end") { $0 + "<-\($1)" }
        return description
    }
    
    public var description: String {
        return diagram()
    }
}
