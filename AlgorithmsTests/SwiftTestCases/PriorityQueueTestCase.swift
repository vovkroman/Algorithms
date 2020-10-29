import XCTest
import Foundation
@testable import Algorithms

extension TestTask: Comparable {
    public static func < (lhs: TestTask, rhs: TestTask) -> Bool {
        return lhs.compare(rhs) == .compareEqualTo
    }
}

class PriorityQueueTestCase: XCTestCase {

    func testInitPriorityQueue() {
        let priorityQueue = PriorityQueue<Int>(){ $0 < $1 }
        
        XCTAssertTrue(priorityQueue.isEmpty)
        XCTAssertTrue(priorityQueue.count == 0)
    }
    
    func testEnqueueDequePriorityQueue() {
        var priorityQueue = PriorityQueue<Int>(){ $0 < $1 }
        priorityQueue.enqueue(2)
        priorityQueue.enqueue(10)
        priorityQueue.enqueue(1)
        priorityQueue.enqueue(0)
        
        XCTAssertTrue(priorityQueue.dequeue() == Optional(0))
        XCTAssertTrue(priorityQueue.dequeue() == Optional(1))
        XCTAssertTrue(priorityQueue.dequeue() == Optional(2))
        XCTAssertTrue(priorityQueue.dequeue() == Optional(10))
    }
    
    func testFindIndexPriorityQueue() {
        let priorityQueue = PriorityQueue<Int>(array: [5, 10, 0, 3]){ $0 < $1 }

        XCTAssertTrue(priorityQueue.index(of: 0) == Optional(0))
        XCTAssertTrue(priorityQueue.index(of: 3) == Optional(1))
        XCTAssertTrue(priorityQueue.index(of: 5) == Optional(2))
        XCTAssertTrue(priorityQueue.index(of: 10) == Optional(3))
    }
    
    func testPeakPriorityQueue() {
        var priorityQueue = PriorityQueue<Int>(array: [5, 10, 0, 3]){ $0 < $1 }

        XCTAssertTrue(priorityQueue.peek() == priorityQueue.dequeue())
        XCTAssertTrue(priorityQueue.peek() == priorityQueue.dequeue())
        XCTAssertTrue(priorityQueue.peek() == priorityQueue.dequeue())
        XCTAssertTrue(priorityQueue.peek() == priorityQueue.dequeue())
    }
    /** Compare 2 implementation of PriorityQueue
     * {(*PriorityQueue(Swift)* vs *ObjCPriorityQueue(Objective-C)*)}
     */
    func testBenchmark() {
        let objPriorityQueue = ObjCPriorityQueue<TestTask>()
        var swiftPriorityQueue = PriorityQueue<TestTask>() { $0 < $1 }
        
        let measure_objC = ParkBenchTimer()
        for i in 0...10_000 {
            let priority = UInt.random(in: 0...100_000)
            let task = TestTask("\(i)", andPriority: priority)
            objPriorityQueue.enqueue(task)
        }
        
        print("PriorityQueue(Objective-C) timer finished test for \(measure_objC.stop())")
        //PriorityQueue(Objective-C) timer finished test for 0.05833399295806885
        let measure_swift = ParkBenchTimer()
        for i in 0...10_000 {
            let priority = UInt.random(in: 0...100_000)
            let task = TestTask("\(i)", andPriority: priority)
            swiftPriorityQueue.enqueue(task)
        }
        print("PriorityQueue(Swift) timer finished test for \(measure_swift.stop())")
        //PriorityQueue(Swift) timer finished test for 0.06147909164428711
    }
}
