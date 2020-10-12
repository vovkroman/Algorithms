//
//  AlgorithmsTests.swift
//  AlgorithmsTests
//
//  Created by Roman Vovk on 07.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import XCTest
@testable import Algorithms

extension Array where Element: Keyable {
    
    @discardableResult
    func find<T: Comparable>(value searchValue: T) -> Index? where Element.KeyType == T{
        for (index, value) in self.enumerated() {
            if value.key == searchValue {
                return index
            }
        }
        return nil
    }
}

class ObjC {
    var priority: UInt32
    
    init(_ p: UInt32) {
        self.priority = p
    }
}


extension ObjC: Keyable {
    var key: UInt32 { return self.priority }
}

class AlgorithmsTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSwiftPriorityPerformanceExample() throws {//SwiftPriority timer 1.8580549955368042
        // This is an example of a performance test case.
        var swift = PriorityQueue<ObjC>(sort: {$0.priority < $1.priority})
        //self.measure {
        let timer = ParkBenchTimer()
        for _ in 0...500_000 {
            let r = UInt32.random(in: 0...500_000)
            let obj1 = ObjC(r)
            swift.enqueue(obj1)
        }
        
        while swift.count != 0 {
            swift.dequeue()
        }
        
        print("SwiftPriority timer \(timer.stop())")
        // Put the code you want to measure the time of here.
    }
    
    func testCppPriorityPerformanceExample() throws { //CppPriorityQueue timer 0.3891289234161377
        // This is an example of a performance test case.
        let pQ = CppPriorityQueue<ObjC>(.OrderedDescending)
        let timer = ParkBenchTimer()
        for _ in 0...500_000 {
            let r = UInt32.random(in: 0...500_000)
            let obj1 = ObjC(r)
            pQ.enqueue(obj1, value: r)
        }
        
        while pQ.count() != 0 {
            pQ.dequeue()
        }
        
        print("CppPriorityQueue timer \(timer.stop())")
    }
    
    func testOderedSetPriorityPerformanceExample() throws {
        // This is an example of a performance test case.
        var oderedArray = OrderedArray<ObjC>()
        var regularArray: [ObjC] = []
        
        for _ in 0...10_000 {
            let i = UInt32.random(in: 0..<500_000)
            oderedArray.insert(newElement: ObjC(i))
            regularArray.append(ObjC(i))
        }
        
        let timer1 = ParkBenchTimer()
        for _ in 0...10_000 {
            let g = UInt32.random(in: 0..<500_000)
            oderedArray.lookUp(of: g)
        }
        //Swift OrderedArray timer 0.025035977363586426
        print("Swift OrderedArray timer \(timer1.stop())")

        let timer2 = ParkBenchTimer()
        for _ in 0...10_000 {
            let g = UInt32.random(in: 0..<500_000)
            regularArray.find(value: g)
        }
        
        //Array timer 44.04200994968414
        print("Array timer \(timer2.stop())")
    }
    
    
    func testBinarySearchPerformanceExample() throws {
        // This is an example of a performance test case.
        var array: [ObjC] = [ObjC(10), ObjC(20), ObjC(5), ObjC(8), ObjC(2), ObjC(11)]
        array.sort { (obj1, obj2) -> Bool in
            return obj1.priority < obj2.priority
        }
        print(array.binarySearch(5))
    }
}
