import XCTest
@testable import Algorithms

class SegmentTreeTestCase: XCTestCase {

    func testQuerySegmentTree() throws {
        let items = [2, 1, 8, 6, 0, 10]
        let segmentTree = SegmentTree(array: items, function: max)
        /*
         * Get max value on the interval [0, 2] = 8
         * Get max value on the interval [3, items.count - 1] = 10
         * Get max value on the interval [1, items.count - 2] = 8
         */
        
        XCTAssertTrue(segmentTree.query(leftBound: 0, rightBound: 2) == 8)
        XCTAssertTrue(segmentTree.query(leftBound: 3, rightBound: items.count - 1) == 10)
        XCTAssertTrue(segmentTree.query(leftBound: 1, rightBound: items.count - 2) == 8)
    }
    
    func testQueryAndUpdateSegmentTree() throws {
        let items = [2, 1, 8, 6, 0, 10]
        let segmentTree = SegmentTree(array: items, function: max)
        /*
         * Get max value on the interval [0, 2] = 8
         */
        
        XCTAssertTrue(segmentTree.query(leftBound: 0, rightBound: 2) == 8)
        segmentTree.replaceItem(at: 2, withItem: -1)
        /*
         * Now array has been updated to [2, 1, -1, 6, 0, 10], and [0, 2] = 2
         **/
        XCTAssertTrue(segmentTree.query(leftBound: 0, rightBound: 2) == 2)
    }
    
}
