import Foundation

/*** SingleLinkedList is wrapper LinkedList adding COW (Copy-on-write) semantic optimization technic
 **/
public struct SingleLinkedList<Element> {
    @usableFromInline
    internal var _storage: Box<LinkedList<Element>>
}

extension SingleLinkedList: ExpressibleByArrayLiteral {
    
    @inlinable
    public init() {
        _storage = Box(value: LinkedList())
    }
    
    @inlinable
    public init(arrayLiteral elements: Element...) {
        let linkedList: LinkedList = LinkedList(elements)
        _storage = Box(value: linkedList)
    }
}

extension SingleLinkedList {
    
    @inlinable
    public mutating func push(_ x: Element) {
        _storage.value.push(x)
    }
    
    @inlinable
    public mutating func pop() -> Element? {
        return _storage.value.pop()
    }
}

extension SingleLinkedList: IteratorProtocol, Sequence {
    
    @inlinable
    public mutating func next() -> Element? {
        return _storage.value.pop()
    }
}


extension SingleLinkedList: CustomStringConvertible {
    
    private func diagram() -> String {
        return _storage.value.description
    }
    
    public var description: String {
        return diagram()
    }
}
