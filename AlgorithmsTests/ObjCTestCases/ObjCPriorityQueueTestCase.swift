import XCTest

class ObjCPriorityQueueTestCase: XCTestCase {

    typealias PriorityQueue<T: CFComparableProtocol> = CFPriorityQueue<T>
    
    func testEnqueueDeque() throws {
        let priorityQueue = PriorityQueue<TestTask>()
        
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task2", andPriority: 1))
        priorityQueue.enqueue(TestTask("Task3", andPriority: 11))
        priorityQueue.enqueue(TestTask("Task4", andPriority: 5))
        
        XCTAssertEqual(priorityQueue.dequeue()?.message, .some("Task2 with priority 1"))
        XCTAssertEqual(priorityQueue.dequeue()?.message, .some("Task4 with priority 5"))
        XCTAssertEqual(priorityQueue.dequeue()?.message, .some("Task1 with priority 10"))
        XCTAssertEqual(priorityQueue.dequeue()?.message, .some("Task3 with priority 11"))
    }
    
    func testPriorityQueueCount() {
        let priorityQueue = PriorityQueue<TestTask>()
        
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task2", andPriority: 1))
        priorityQueue.enqueue(TestTask("Task3", andPriority: 11))
        priorityQueue.enqueue(TestTask("Task4", andPriority: 5))
        
        XCTAssertEqual(priorityQueue.count(), 4)
    }
    
    
    func testPriorityQueueContains() {
        let priorityQueue = PriorityQueue<TestTask>()
        
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task2", andPriority: 1))
        priorityQueue.enqueue(TestTask("Task3", andPriority: 11))
        priorityQueue.enqueue(TestTask("Task4", andPriority: 5))
        
        XCTAssert(priorityQueue.contains(TestTask("Task3", andPriority: 11)))
    }
    
    func testPriorityQueueCountOfObjects() {
        let priorityQueue = PriorityQueue<TestTask>()
        
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        
        XCTAssertEqual(priorityQueue.count(ofObject: TestTask("Task1", andPriority: 10)), 4)
    }
    
    
    func testPriorityQueueApply() {
        let priorityQueue = PriorityQueue<TestTask>()
        
        priorityQueue.enqueue(TestTask("Task1", andPriority: 10))
        priorityQueue.enqueue(TestTask("Task2", andPriority: 1))
        priorityQueue.enqueue(TestTask("Task3", andPriority: 11))
        priorityQueue.enqueue(TestTask("Task4", andPriority: 5))
        
        priorityQueue.enumerateObjects { (task) in
            task.update("Test")
        }
        
        priorityQueue.enumerateObjects { (task) in
            XCTAssertEqual(task.message, "Test")
        }
    }
}
