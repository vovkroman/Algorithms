import XCTest
@testable import Algorithms

class QueueTestCase: XCTestCase {

    func testEnqueueDequeue() throws {
        let items = [2, 8, 6, 7, 11, 1, 0]
        var queue = Queue<Int>()
        for item in items {
            queue.enqueue(item)
        }
        /**
         * amount of items in Queue, should be the same as in items array
         */
        XCTAssertTrue(queue.count == items.count)
        /**
        * Queue should return items at the same order as items array does
        */
        for item in items {
            XCTAssertTrue(queue.dequeue() == .some(item))
        }
        /**
        * Queue should return nil, since all items have been returned and poped
        */
        XCTAssertTrue(queue.dequeue() == nil)
    }
    
    func testEmpty() {
        let queue = Queue<Int>()
        XCTAssertTrue(queue.isEmpty)
    }
    
    func testFront() {
        let items = [2, 8, 6, 7, 11, 1, 0]
        var queue = Queue<Int>()
        for item in items {
            queue.enqueue(item)
        }
        /**
        * Queue should return item at the front, (2, currently), since it is not removed after being returned
        */
        for item in items {
            XCTAssertTrue(queue.front == .some(2))
        }
        
    }
}
