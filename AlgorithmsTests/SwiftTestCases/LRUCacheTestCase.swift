import XCTest
@testable import Algorithms

class LRUCacheTestCase: XCTestCase {
    
    func testCacheSetAndGet() throws {
        let cache = LRUCache<String, Float>(capacity: 7)
        cache["AAPL"] = 114.63
        cache["GOOG"] = 533.75
        cache["YHOO"] = 50.67
        cache["TWTR"] = 38.91
        cache["BABA"] = 109.89
        cache["YELP"] = 55.17
        cache["BABA"] = 109.80
        cache["TSLA"] = 231.43
        cache["AAPL"] = 113.41
        cache["GOOG"] = 533.60
        cache["AAPL"] = 113.01
        
        //Retrieve
        let item = cache["AAPL"]//113.01
        XCTAssertTrue(item == Optional(113.01))
    }
    
    func testRemovedUnused() throws {
        let cache = LRUCache<String, Float>(capacity: 7)
        cache["OOOO"] = 20.01
        cache["AAPL"] = 114.63
        cache["GOOG"] = 533.75
        cache["YHOO"] = 50.67
        cache["TWTR"] = 38.91
        cache["BABA"] = 109.89
        cache["YELP"] = 55.17
        cache["BABA"] = 109.80
        cache["TSLA"] = 231.43
        cache["AAPL"] = 113.41
        cache["GOOG"] = 533.60
        cache["AAPL"] = 113.01
        
        //Retrieve
        let item = cache["OOOO"] // nil, since is used only once
        XCTAssertTrue(item == nil)
    }
    
}
