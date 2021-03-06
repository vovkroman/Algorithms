import XCTest
@testable import Algorithms

class OrderedSetTestCase: XCTestCase {
    
    func testInit() {
        let orderedSet = OrderedSet<Int>(collection: Set([1, 8, 6, 5, 9]))
        
        XCTAssertTrue(orderedSet.count == 5)
    }
    
    
    func testOrderedIndexing() {
        let orderedSet = OrderedSet<Int>(collection: [2, 1, 8, 6, 5, 9])
        /**
         * Since OrderedSet stores elements in some order,
         * so we can check value in the same order
         */
        XCTAssertTrue(orderedSet[0] == 1)
        XCTAssertTrue(orderedSet[1] == 2)
        XCTAssertTrue(orderedSet[2] == 5)
        XCTAssertTrue(orderedSet[3] == 6)
        XCTAssertTrue(orderedSet[4] == 8)
        XCTAssertTrue(orderedSet[5] == 9)
    }
    
    func testOrderedRemoveIndex() {
        var orderedSet = OrderedSet<Int>(collection: [2, 1, 8, 6, 5, 9])
        
        let value = 5
        orderedSet.remove(obj: value)
        let result: Result = orderedSet.lookUp(of: value)
        XCTAssertTrue(result == .failure, "OrderedArray doesn't contain \(value)")
    }
    
    func testInsertExistingValue() {
        let orderedSet: OrderedSet<Int> = [2, 1, 8, 6, 5, 9]
        let insertValue = 8
        let result: Result = orderedSet.lookUp(of: insertValue)
        XCTAssertTrue(result == .success(index: 4))
        orderedSet.insert(insertValue)
        XCTAssertTrue(result == .success(index: 4))
    }
    
    func testInsertNonExistingValue() {
        let orderedSet = OrderedSet<Int>(collection: [2, 1, 8, 6, 5, 9])
        let insertValue = 10
        let resultBefore: Result = orderedSet.lookUp(of: insertValue)
        XCTAssertTrue(resultBefore == .failure)
        orderedSet.insert(insertValue)
        let resultAfter: Result = orderedSet.lookUp(of: insertValue)
        XCTAssertTrue(resultAfter == .success(index: 6))
    }
    
    func testRemoveValues() {
        var forEachOrderedSet = OrderedSet<Int>(collection: [2, 1, 8, 6, 5, 9])
        var removeAllOrderedSet = OrderedSet<Int>(collection: [2, 1, 8, 6, 5, 9])

        // one approach to remove
        removeAllOrderedSet.removeAll()
        
        // second approach to remove
        for element in forEachOrderedSet {
            forEachOrderedSet.remove(obj: element as! Int)
        }
        
        XCTAssertTrue(forEachOrderedSet.count == removeAllOrderedSet.count)
    }
    
    /**
     * Compare performance among OrderedArray and OrderedSet (implemented in Algorithms.framework)
     **/
    func testPerformanceExample() throws {
        var orderedArray = OrderedArray<Int>()
        let orderedSet = OrderedSet<Int>()
        var set = Set<Int>()
        
        for _ in 0...10_000 {
            let i = Int.random(in: 0..<500_000)
            orderedArray.insert(newElement: i)
            orderedSet.insert(i)
            set.insert(i)
        }
        
        let measure_set = ParkBenchTimer()
        for _ in 0...10_000 {
            let searchValue = Int.random(in: 0..<500_000)
            set.lookUp(of: searchValue)
            
        }
        print("Set timer finished test for \(measure_set.stop())")
        // **Set** timer finished test for 0.01764702796936035
        
        let measure_orderedArray = ParkBenchTimer()
        for _ in 0...10_000 {
            let searchValue = Int.random(in: 0..<500_000)
            orderedArray.lookUp(of: searchValue)
        }
        print("OrderedArray timer finished test for \(measure_orderedArray.stop())")
        // **OrderedArray** timer finished test for 0.026673078536987305

        let measure_orderedSet = ParkBenchTimer()
        for _ in 0...10_000 {
            let searchValue = Int.random(in: 0..<500_000)
            orderedSet.lookUp(of: searchValue)
        }
        print("OrderedSet timer finished test for \(measure_orderedSet.stop())")
        // **OrderedSet** timer finished test for 0.09929001331329346
    }
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func testPerformanceMesureExample() throws {
//        var orderedArray = Set<Int>()
//        var i = 2
//        var str = ""
//        while i < 2_500_000 {
//            for _ in 0...i {
//                let j = Int.random(in: 0..<500_000)
//                orderedArray.insert(i)
//            }
//
//            let measure_orderedSet = ParkBenchTimer()
//            for _ in 0...i {
//                let j = Int.random(in: 0..<500_000)
//                orderedArray.lookUp(of: j)
//            }
//            let current = "\n\(i)                    \(measure_orderedSet.stop())"
//            str.append(current)
//            i *= 2
//        }
//
//        let filename = getDocumentsDirectory().appendingPathComponent("Set.txt")
//        print(filename)
//        do {
//            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//        }
//    }
}
