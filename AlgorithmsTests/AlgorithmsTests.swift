//
//  AlgorithmsTests.swift
//  AlgorithmsTests
//
//  Created by Roman Vovk on 07.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import XCTest
@testable import Algorithms

import Foundation
import CoreFoundation

public class ParkBenchTimer {

    public let startTime:CFAbsoluteTime
    public var endTime:CFAbsoluteTime?

    public init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    public func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration!
    }

    public var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}


class ObjC {
    var priority: UInt32
    
    init(_ p: UInt32) {
        self.priority = p
    }
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
            // Put the code you want to measure the time of here.
        //}
    }
    
}
