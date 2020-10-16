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

class Obj1 {
    var priority: Int
    
    init(_ p: Int) {
        self.priority = p
    }
}


extension ObjC: Keyable {
    var key: UInt32 { return self.priority }
}

extension Int: Keyable {
    public var key: Int { return self }
}

class AlgorithmsTests: XCTestCase {
    
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
    
//    func testCppPriorityPerformanceExample() throws { //CppPriorityQueue timer 0.3891289234161377
//        // This is an example of a performance test case.
//        let pQ = CppPriorityQueue<ObjC>(.OrderedDescending)
//        let timer = ParkBenchTimer()
//        for _ in 0...500_000 {
//            let r = UInt32.random(in: 0...500_000)
//            let obj1 = ObjC(r)
//            pQ.enqueue(obj1, value: r)
//        }
//        
//        while pQ.count() != 0 {
//            pQ.dequeue()
//        }
//        
//        print("CppPriorityQueue timer \(timer.stop())")
//    }
    
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
    
    
    func testMaxMinPerformanceExample() {
        var arr: [Double] = .init(repeatElement(0.0, count: 1_000_000))
        for i in 0...1_000 {
            arr.insert(Double.random(in: 0...50_000), at: i)
        }//non-Accelerated Executed 1 test, with 0 failures (0 unexpected) in 1.938 (1.941) seconds
        let maxIndex = arr.argmax() //Executed 1 test, with 0 failures (0 unexpected) in 0.830 (0.833) seconds
        let midIndex = arr.argmin()
    }
    
    func testStackPerformanceExample() {
        let stack1 = CppStack<Obj1>()
        
        let timer = ParkBenchTimer()
        for i in 0...1_000_000 {
            stack1.push(Obj1(i))
        }
        
        while !stack1.isEmpty() {
            stack1.top()
        }
        print("Stack C++ timer \(timer.stop())")
        
        var stack2 = Stack<Obj1>()
        
        let timer1 = ParkBenchTimer()
        for i in 0...1_000_000 {
            stack2.push(Obj1(i))
        }
        
        while !stack2.isEmpty {
            stack2.pop()
        }
        print("Stack Swift timer \(timer.stop())")
    }
    
    func testPerformanceOjcPriorityQueue() {
        let pq = ObjCPriorityQueue<Task>()
        pq.enqueue(Task(priority: 2, andName: "2"))
        pq.enqueue(Task(priority: 4, andName: "4"))
        pq.enqueue(Task(priority: 10, andName: "10"))
        pq.enqueue(Task(priority: 3, andName: "3"))
        pq.enqueue(Task(priority: 8, andName: "8"))
        pq.enqueue(Task(priority: 5, andName: "5"))
        pq.enqueue(Task(priority: 11, andName: "11"))
        
        for i in 0...10 {
            print(pq.dequeue())
        }
        
        print(pq.contains(Task(priority: 12, andName: "4")))
    }
}
