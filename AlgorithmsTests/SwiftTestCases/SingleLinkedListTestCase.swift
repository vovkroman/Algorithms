import XCTest
@testable import Algorithms

class SingleLinkedListTestCase: XCTestCase {
    
    func testInitSingleLinkedList() {
        var linkedList: SingleLinkedList = [1, 6, 7, 8]
        XCTAssertTrue(linkedList.pop() == Optional(8))
        XCTAssertTrue(linkedList.pop() == Optional(7))
        XCTAssertTrue(linkedList.pop() == Optional(6))
        XCTAssertTrue(linkedList.pop() == Optional(1))
        XCTAssertTrue(linkedList.pop() == nil)
    }
    
    func testOneElement() {
        var linkedList = SingleLinkedList<Int>()
        linkedList.push(10)
        XCTAssertTrue(linkedList.pop() == Optional(10))
        XCTAssertTrue(linkedList.pop() == nil)
    }
    
    func testSingleLinkedListCow() {
        var list_1 = SingleLinkedList<Int>()
        list_1.push(10)
        list_1.push(20)
        list_1.push(30)
        var list_2 = list_1
        XCTAssertTrue(MemoryAddress(of: &list_1._storage).intValue == MemoryAddress(of: &list_2._storage).intValue)
    }
}
