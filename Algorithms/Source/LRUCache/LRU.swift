import Foundation
/**
**LRU** a nice wrapper that is NSCoding-compliant via the NSKeyedArchiver. Please checkout  (Example)[LRU_Example.rtf] to support this behavior.
 */
 public class LRU: NSObject, NSCoding {
    
    @usableFromInline
    let _cache: LRUCache<AnyHashable, Any>
    
    @usableFromInline
    var capacity: Int {
        return _cache._capacity
    }
    
    public var length: Int {
        return _cache._length
    }
    
    // MARK: -
    
    public init(capacity: Int){
        _cache = LRUCache(capacity: capacity)
    }
    
    // MARK: NSCoding
    
    public required init(coder decoder: NSCoder) {
        let capacity = decoder.decodeInteger(forKey: "capacity")
        self._cache = LRUCache<AnyHashable, Any>(capacity: capacity)
        
        var counter = decoder.decodeInteger(forKey: "counter")
        while counter > 0 {
            let itemDict = decoder.decodeObject(forKey: String(counter)) as! [AnyHashable : Any]
            let itemKeys = Array(itemDict.keys)
            let itemKey = itemKeys[0]
            self._cache[itemKey] = itemDict[itemKey]
            counter -= 1
        }
    }
    
    public func encode(with encoder: NSCoder) {
        var counter = 0
        var queueCurrent = _cache._queue._head
        
        while let key = queueCurrent?._key {
            if let value = queueCurrent?._value {
                counter += 1
                encoder.encode([key: value], forKey: String(counter))
            }
            queueCurrent = queueCurrent?._next
        }
        
        encoder.encode(self._cache._capacity, forKey: "capacity")
        encoder.encode(counter, forKey: "counter")
    }
    
    // MARK: Printable
    
    public override var description: String {
        return "LRU Cache(\(self._cache._length)) \n" + self._cache._queue.display()
    }
    
    // MARK: -
    
    @inlinable
    public func put(_ key: AnyHashable, _ value: Any) {
        _cache[key] = value
    }
    
    @inlinable
    public func get(_ key: AnyHashable) -> Any? {
        return _cache[key]
    }
    
 }
