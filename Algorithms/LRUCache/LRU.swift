 //
 // Example
 //
/*
 import Foundation

 //...

         // Create a NSCoding compliant cache with capacity 7
         let lru = LRU(capacity: 7)
         lru.put("AAPL", 114.63)
         lru.put("GOOG", 533.75)
         lru.put("YHOO", 50.67)
         lru.put("TWTR", 38.91)
         lru.put("BABA", 109.89)
         lru.put("YELP", 55.17)
         lru.put("BABA", 109.80)
         lru.put("TSLA", 231.43)
         lru.put("AAPL", 113.41)
         lru.put("GOOG", 533.60)
         lru.put("AAPL", 113.01)
         
         //Retrieve
         if let item = lru.get("AAPL") {
             print("Key: AAPL Value: \(item)")
         } else {
             print("Item not found.")
         }

 /* OUTPUT
     Key: AAPL Value: 113.01
 */
         
         //Describe
         print(lru)
         
 /* OUTPUT
     LRU Cache(7)
     Key: AAPL Value: Optional(113.01)
     Key: GOOG Value: Optional(533.6)
     Key: TSLA Value: Optional(231.43)
     Key: BABA Value: Optional(109.8)
     Key: YELP Value: Optional(55.17)
     Key: TWTR Value: Optional(38.91)
     Key: YHOO Value: Optional(50.67)
 */
         
         // Save to disk
         let myPathList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
         let path = (myPathList[0] as NSString).appendingPathComponent("LRU.archive")
         
         if NSKeyedArchiver.archiveRootObject(lru, toFile: path) {
             print("success")
         } else {
             print("failed")
         }
         
         // fetch from disk
         let unarchivedLRU = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! LRU
         
         //Describe
         print(unarchivedLRU)

 /* OUTPUT
     LRU Cache(7)
     Key: AAPL Value: Optional(113.01)
     Key: GOOG Value: Optional(533.6)
     Key: TSLA Value: Optional(231.43)
     Key: BABA Value: Optional(109.8)
     Key: YELP Value: Optional(55.17)
     Key: TWTR Value: Optional(38.91)
     Key: YHOO Value: Optional(50.67)
 */

 //...
 
 */

import Foundation

class LRU: NSObject, NSCoding {
    
    private let _cache: LRUCache<AnyHashable, Any>
    
    var capacity: Int {
        return self._cache.capacity
    }
    
    var length: Int {
        return self._cache.length
    }
    
    // MARK: -
    
    init(capacity: Int){
        self._cache = LRUCache(capacity: capacity)
    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
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
    
    
    func encode(with encoder: NSCoder) {
        var counter = 0
        var queueCurrent = self._cache.queue.head
        
        while let key = queueCurrent?.key {
            if let value = queueCurrent!.value {
                counter += 1
                encoder.encode([key: value], forKey: String(counter))
            }
            queueCurrent = queueCurrent?.next
        }
        
        encoder.encode(self._cache.capacity, forKey: "capacity")
        encoder.encode(counter, forKey: "counter")
    }
    
    // MARK: Printable
    
    override var description: String {
        return "LRU Cache(\(self._cache.length)) \n" + self._cache.queue.display()
    }
    
    // MARK: -
    
    func put(_ key: AnyHashable, _ value: Any) {
        self._cache[key] = value
    }
    
    func get(_ key: AnyHashable) -> Any? {
        return self._cache[key]
    }
    
}
