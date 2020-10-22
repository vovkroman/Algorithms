//
//  OderedArrayTestCase.swift
//  AlgorithmsTests
//
//  Created by Roman Vovk on 20.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import XCTest
@testable import Algorithms

fileprivate extension Array where Element: Keyable & Equatable {
    @discardableResult
    func find<T: Comparable>(value searchValue: T) -> Index? where Element.KeyType == T {
        return firstIndex { $0.key == searchValue }
    }
}

extension Int: Keyable {
    public var key: Int { return self }
}

class OderedArrayTestCase: XCTestCase {

    func testInit() {
        let oderedArray = OrderedArray<Int>(array: [1, 8, 6, 5, 9])
        
        XCTAssertTrue(oderedArray.count == 5)
        XCTAssertTrue(!oderedArray.isEmpty)
    }
    
    func testOderedIndexing() {
        let oderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        /**
         * Since OrderedArray stores elements in some odere,
         * so we can check value in the same order
         */
        XCTAssertTrue(oderedArray[0] == 1)
        XCTAssertTrue(oderedArray[1] == 2)
        XCTAssertTrue(oderedArray[2] == 5)
        XCTAssertTrue(oderedArray[3] == 6)
        XCTAssertTrue(oderedArray[4] == 8)
        XCTAssertTrue(oderedArray[5] == 9)
    }
    
    func testOderedRemoveIndex() {
        var oderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        
        let removedValue = oderedArray.removeAtIndex(index: 2)
        let result: Result = oderedArray.lookUp(of: removedValue)
        XCTAssertTrue(result == .failure, "OrderedArray doesn't contain \(removedValue)")
    }
    
    func testInsertExistingValue() {
        var oderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        let insertValue = 8
        let result: Result = oderedArray.lookUp(of: insertValue)
        XCTAssertTrue(result == .success(index: 4))
        oderedArray.insert(newElement: insertValue)
        XCTAssertTrue(result == .success(index: 4))
    }
    
    func testInsertNonExistingValue() {
        var oderedArray = OrderedArray<Int>(array: [2, 1, 8, 6, 5, 9])
        let insertValue = 10
        let resultBefore: Result = oderedArray.lookUp(of: insertValue)
        XCTAssertTrue(resultBefore == .failure)
        oderedArray.insert(newElement: insertValue)
        let resultAfter: Result = oderedArray.lookUp(of: insertValue)
        XCTAssertTrue(resultAfter == .success(index: 6))
    }
    
    /**
     * Compare performance among Array and OrderedArray
     **/
    func testPerformanceExample() throws {
        var oderedArray = OrderedArray<Int>()
        var regularArray: [Int] = []
        
        for _ in 0...1_000 {
            let i = Int.random(in: 0..<500_000)
            oderedArray.insert(newElement: i)
            regularArray.append(i)
        }
        
        let measure_oderedArray = ParkBenchTimer()
        for _ in 0...1_000 {
            let searchValue = Int.random(in: 0..<500_000)
            oderedArray.lookUp(of: searchValue)
        }
        print("OrderedArray timer finished test for \(measure_oderedArray.stop())")
        // OrderedArray timer finished test for **0.0037450790405273438**
        
        let measure_array = ParkBenchTimer()
        for _ in 0...1_000 {
            let searchValue = Int.random(in: 0..<500_000)
            regularArray.find(value: searchValue)
        }
        print("Array timer finished test for \(measure_array.stop())")
        //Array timer finished test for **0.28222596645355225**
    }
}
