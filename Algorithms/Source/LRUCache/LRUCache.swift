import Foundation

/// A node in the Double-linked list
class Node<K, V> {
    @usableFromInline
    var _next: Node?
    
    @usableFromInline
    var _previous: Node?
    
    @usableFromInline
    var _key: K
    
    @usableFromInline
    var _value: V?
    
    @usableFromInline
    init(key: K, value: V?) {
        self._key = key
        self._value = value
    }
}

/**
**Double linked list** is a linked data structure that consists of a set of sequentially linked records called nodes. Each node contains three mandatory fields: two link fields (references to the previous and to the next node in the sequence of nodes) and one data field.
 
**Application**:
There are various application of doubly linked list in the real world. Some of them can be listed as:

- Doubly linked list can be used in navigation systems where both front and back navigation is required.
- It is used by browsers to implement backward and forward navigation of visited web pages i.e. back and forward button.
- It is also used by various application to implement Undo and Redo functionality.
- It can also be used to represent deck of cards in games.
- It is also used to represent various states of a game.

**Performance**:
 - build is O(n);
 - searching item is O(n);
 - iterating  item is O(n);
 - Inserting is O(1);
 - deleting  item is O(1);
 
**Drawback**:
 Not many but doubly linked list has few disadvantages also which can be listed below:
- It uses extra memory when compared to array and singly linked list.
- Since elements in memory are stored randomly, hence elements are accessed sequentially no direct access is allowed.*/
final class DoubleLinkedList<K, V> {
    @usableFromInline
    var _head: Node<K, V>?
    
    @usableFromInline
    var _tail: Node<K, V>?
    
    init() {}
    
    @inlinable
    public func addToHead(_ node: Node<K, V>) {
        if self._head == nil  {
            self._head = node
            self._tail = node
        } else {
            let temp = self._head
            
            self._head?._previous = node
            self._head = node
            self._head?._next = temp
        }
    }
    
    @inlinable
    public func remove(_ node: Node<K, V>) {
        if node === self._head {
            if self._head?._next != nil {
                self._head = self._head?._next
                self._head?._previous = nil
            } else {
                self._head = nil
                self._tail = nil
            }
        } else if node._next != nil {
            node._previous?._next = node._next
            node._next?._previous = node._previous
        } else {
            node._previous?._next = nil
            self._tail = node._previous
        }
    }
    
    @usableFromInline
    func display() -> String {
        var description = ""
        var current = _head
        
        while let cur = current {
            description += "Key: \(cur._key) Value: \(String(describing: cur._value)) \n"
            
            current = cur._next
        }
        return description
    }
}

/**
**LRU Cache** - a Least Recently Used (LRU) Cache organizes items in order of use, allowing you to quickly identify which item hasn't been used for the longest amount of time.
 
**Application**:
 - Super fast accesses. LRU caches store items in order from most-recently used to least-recently used. That means both can be accessed in **O(1)** time.

- Super fast updates. Each time an item is accessed, updating the cache takes **O(1)** time.

**Performance**:
 - space - O(n);
 - get least recently used item - O(1);
 - access item - O(1);
 
**Drawback**:
- Space heavy. An LRU cache tracking nn items requires a linked list of length nn, and a hash map holding nn items. That's **O(n)** space, but it's still two data structures (as opposed to one).*/
public class LRUCache<K: Hashable, V> {
    
    @usableFromInline
    internal let _capacity: Int
    
    @usableFromInline
    internal var _length = 0
    
    internal let _queue: DoubleLinkedList<K, V>
    
    internal var _hashtable: [K: Node<K, V>]
    
    /**
    Least Recently Used "LRU" Cache, capacity is the number of elements to keep in the Cache.
    */
    public init(capacity: Int) {
        _capacity = capacity
        
        _queue = DoubleLinkedList()
        _hashtable = [K : Node<K, V>](minimumCapacity: _capacity)
    }
    
    public subscript (key: K) -> V? {
        get {
            if let node = _hashtable[key] {
                _queue.remove(node)
                _queue.addToHead(node)
                
                return node._value
            } else {
                return nil
            }
        }
        
        set(value) {
            if let node = _hashtable[key] {
                node._value = value
                
                _queue.remove(node)
                _queue.addToHead(node)
            } else {
                let node = Node(key: key, value: value)
                
                if _length < _capacity {
                    _queue.addToHead(node)
                    _hashtable[key] = node
                    
                    _length += 1
                } else {
                    _hashtable.removeValue(forKey: _queue._tail!._key)
                    _queue._tail = _queue._tail?._previous
                    
                    if let node = _queue._tail {
                        node._next = nil
                    }
                    
                    _queue.addToHead(node)
                    _hashtable[key] = node
                }
            }
        }
    }
}

extension LRUCache: CustomStringConvertible {
    public var description : String {
        return "LRU Cache(\(_length)) \n" + _queue.display()
    }
}
