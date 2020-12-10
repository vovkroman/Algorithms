//##Performance: Time: O(1), Space: O(1) assumes no collisions into the hashtable.
import Foundation

class Node<K, V> {
    var next: Node?
    var previous: Node?
    var key: K
    var value: V?
    
    init(key: K, value: V?) {
        self.key = key
        self.value = value
    }
}

class DoubleLinkedList<K, V> {
    
    var head: Node<K, V>?
    var tail: Node<K, V>?
    
    init() {}
    
    func addToHead(_ node: Node<K, V>) {
        if self.head == nil  {
            self.head = node
            self.tail = node
        } else {
            let temp = self.head
            
            self.head?.previous = node
            self.head = node
            self.head?.next = temp
        }
    }
    
    func remove(_ node: Node<K, V>) {
        if node === self.head {
            if self.head?.next != nil {
                self.head = self.head?.next
                self.head?.previous = nil
            } else {
                self.head = nil
                self.tail = nil
            }
        } else if node.next != nil {
            node.previous?.next = node.next
            node.next?.previous = node.previous
        } else {
            node.previous?.next = nil
            self.tail = node.previous
        }
    }
    
    func display() -> String {
        var description = ""
        var current = self.head
        
        while current != nil {
            description += "Key: \(current!.key) Value: \(String(describing: current?.value)) \n"
            
            current = current?.next
        }
        return description
    }
}


class LRUCache<K : Hashable, V> : CustomStringConvertible {
    
    let capacity: Int
    var length = 0
    
    internal let queue: DoubleLinkedList<K, V>
    fileprivate var hashtable: [K : Node<K, V>]
    
    /**
    Least Recently Used "LRU" Cache, capacity is the number of elements to keep in the Cache.
    */
    init(capacity: Int) {
        self.capacity = capacity
        
        self.queue = DoubleLinkedList()
        self.hashtable = [K : Node<K, V>](minimumCapacity: self.capacity)
    }
    
    subscript (key: K) -> V? {
        get {
            if let node = self.hashtable[key] {
                self.queue.remove(node)
                self.queue.addToHead(node)
                
                return node.value
            } else {
                return nil
            }
        }
        
        set(value) {
            if let node = self.hashtable[key] {
                node.value = value
                
                self.queue.remove(node)
                self.queue.addToHead(node)
            } else {
                let node = Node(key: key, value: value)
                
                if self.length < capacity {
                    self.queue.addToHead(node)
                    self.hashtable[key] = node
                    
                    self.length += 1
                } else {
                    hashtable.removeValue(forKey: self.queue.tail!.key)
                    self.queue.tail = self.queue.tail?.previous
                    
                    if let node = self.queue.tail {
                        node.next = nil
                    }
                    
                    self.queue.addToHead(node)
                    self.hashtable[key] = node
                }
            }
        }
    }
        
    var description : String {
        return "LRU Cache(\(self.length)) \n" + self.queue.display()
    }
}
