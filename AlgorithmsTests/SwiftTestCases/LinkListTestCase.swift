import XCTest
@testable import Algorithms

class LinkListTestCase: XCTestCase {

    func testInitLinkedList() {
        var linkedList: LinkedList = [1, 6, 7, 8]
        print(linkedList)
        XCTAssertTrue(linkedList.pop() == Optional(8))
        XCTAssertTrue(linkedList.pop() == Optional(7))
        XCTAssertTrue(linkedList.pop() == Optional(6))
        XCTAssertTrue(linkedList.pop() == Optional(1))
        XCTAssertTrue(linkedList.pop() == nil)
    }
    
    func testOneElement() {
        var linkedList = LinkedList<Int>()
        linkedList.push(10)
        XCTAssertTrue(linkedList.pop() == Optional(10))
        XCTAssertTrue(linkedList.pop() == nil)
    }
}
