import XCTest
@testable import Algorithms

class StackTestCase: XCTestCase {

    func testPushPop() throws {
        let items = [2, 8, 6, 7, 11, 1, 0]
        var stack = Stack<Int>()
        for item in items {
            stack.push(item)
        }
        /**
         * amount of items in Stack, should be the same as in items array
         */
        XCTAssertTrue(stack.count == items.count)
        /**
        * Stack should return items in reverse order as items array does
        */
        for item in items.reversed() {
            XCTAssertTrue(stack.pop() == .some(item))
        }
        /**
        * Stack should return nil, since all items have been returned and poped
        */
        XCTAssertTrue(stack.pop() == nil)
    }
    
    func testEmpty() {
        let stack = Stack<Int>()
        XCTAssertTrue(stack.isEmpty)
    }
    
    func testFront() {
        let items = [2, 8, 6, 7, 11, 1, 0]
        var stack = Stack<Int>()
        for item in items {
            stack.push(item)
        }
        /**
        * Stack should return item at the last position, (0, currently), since it is not removed after being returned
        */
        for _ in items {
            XCTAssertTrue(stack.top == .some(0))
        }
        
    }
}
