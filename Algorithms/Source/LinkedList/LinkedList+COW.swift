import Foundation

/** **SingleLinkedList** is wrapper LinkedList adding COW (Copy-on-write) semantic optimization technic.
 * SingleLinkedList has the same complexity as LinkedList,
 *  but additionaly contains logic to suuport COW semantic optimization technic
 **/
public struct SingleLinkedList<Element> {
    @usableFromInline
    internal var _storage: Box<LinkedList<Element>>
}

extension SingleLinkedList: ExpressibleByArrayLiteral {
    
    /// see LinkedList init()
    public init() {
        _storage = Box(value: LinkedList())
    }
    
    /// see LinkedList init(arrayLiteral elements: Element...)
    public init(arrayLiteral elements: Element...) {
        let linkedList: LinkedList = LinkedList(elements)
        _storage = Box(value: linkedList)
    }
}

extension SingleLinkedList {
    
    /// see LinkedList push(_ x: Element)
    @inlinable
    public mutating func push(_ x: Element) {
        _storage.value.push(x)
    }
    
    /// see LinkedList pop() -> Element?
    @inlinable
    public mutating func pop() -> Element? {
        return _storage.value.pop()
    }
}

extension SingleLinkedList: IteratorProtocol, Sequence {
    
    /// see LinkedList func next() -> Element?
    @inlinable
    public mutating func next() -> Element? {
        return _storage.value.pop()
    }
}


extension SingleLinkedList: CustomStringConvertible {
    
    /// see LinkedList diagram() -> String
    private func diagram() -> String {
        return _storage.value.description
    }
    
    /// see LinkedList description
    public var description: String {
        return diagram()
    }
}
