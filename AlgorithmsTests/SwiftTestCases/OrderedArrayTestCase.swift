//
//  OrderedArrayTestCase.swift
//  AlgorithmsTests
//
//  Created by Roman Vovk on 20.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import XCTest
@testable import Algorithms

fileprivate extension ContiguousArray where Element: Keyable & Equatable {
    @discardableResult
    func find<T: Comparable>(value searchValue: T) -> Index? where Element.KeyType == T {
        return firstIndex { $0.key == searchValue }
    }
}

extension Int: Keyable {
    public var key: Int { return self }
}

fileprivate struct Test {
    typealias KeyType = Int
    
    let i: Int
    
    public var key: Int { return i }
    
    init(_ i: Int) {
        self.i = i
    }
}

extension Test: Comparable, Hashable {
    var hashValue: Int { return i }
    
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.i == rhs.i
    }
    
    static func < (lhs: Test, rhs: Test) -> Bool {
        return lhs.i < rhs.i
    }
}

class OrderedArrayTestCase: XCTestCase {

    func testInit() {
        let orderedArray = OrderedArray<Int>(array: [1, 8, 6, 5, 9])
        
        XCTAssertTrue(orderedArray.count == 5)
        XCTAssertTrue(!orderedArray.isEmpty)
    }
    
    func testOrderedIndexing() {
        let orderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        /**
         * Since OrderedArray stores elements in some order,
         * so we can check value in the same order
         */
        XCTAssertTrue(orderedArray[0] == 1)
        XCTAssertTrue(orderedArray[1] == 2)
        XCTAssertTrue(orderedArray[2] == 5)
        XCTAssertTrue(orderedArray[3] == 6)
        XCTAssertTrue(orderedArray[4] == 8)
        XCTAssertTrue(orderedArray[5] == 9)
    }
    
    func testOrderedRemoveIndex() {
        var orderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        
        let removedValue = orderedArray.removeAtIndex(index: 2)
        let result: Result = orderedArray.lookUp(of: removedValue)
        XCTAssertTrue(result == .failure, "OrderedArray doesn't contain \(removedValue)")
    }
    
    func testInsertExistingValue() {
        var orderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        let insertValue = 8
        let result: Result = orderedArray.lookUp(of: insertValue)
        XCTAssertTrue(result == .success(index: 4))
        orderedArray.insert(newElement: insertValue)
        XCTAssertTrue(result == .success(index: 4))
    }
    
    func testInsertNonExistingValue() {
        var orderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        let insertValue = 10
        let resultBefore: Result = orderedArray.lookUp(of: insertValue)
        XCTAssertTrue(resultBefore == .failure)
        orderedArray.insert(newElement: insertValue)
        let resultAfter: Result = orderedArray.lookUp(of: insertValue)
        XCTAssertTrue(resultAfter == .success(index: 6))
    }
    
    /**
     * Compare performance among regular Array and OrderedArray (implemented in Algorithms.framework)
     **/
    func testPerformanceExample() throws {
        var orderedArray = OrderedArray<Int>()
        var regularArray: ContiguousArray<Int> = []
        
        for _ in 0...1_000 {
            let i = Int.random(in: 0..<500_000)
            orderedArray.insert(newElement: i)
            regularArray.append(i)
        }
        
        let measure_orderedArray = ParkBenchTimer()
        for _ in 0...1_000 {
            let searchValue = Int.random(in: 0..<500_000)
            orderedArray.lookUp(of: searchValue)
        }
        print("OrderedArray timer finished test for \(measure_orderedArray.stop())")
        // **OrderedArray** timer finished test for **0.0037450790405273438**
        
        let measure_array = ParkBenchTimer()
        for _ in 0...1_000 {
            let searchValue = Int.random(in: 0..<500_000)
            regularArray.find(value: searchValue)
        }
        print("Array timer finished test for \(measure_array.stop())")
        //**Array** timer finished test for **0.28222596645355225**
    }
}
