import XCTest
@testable import Algorithms

class SearchArrayTestCase: XCTestCase {
    
    func testSearchesOntoArray() throws {
        var arr: [Int] = .init(repeating: 0, count: 1_000_000)
        for i in 0..<arr.count {
            arr[i] = i
        }
        
        let measure_binary = ParkBenchTimer()
        XCTAssert(arr.binarySearch(15, from: 0, to: arr.count - 1) == 15)
        XCTAssert(arr.binarySearch(1000, from: 0, to: arr.count - 1) == 1000)
        print("Binary search finished working for \(measure_binary.stop())")
        //*Binary* search finished working for 0.00017595291137695312
        
        let measure_interpolation = ParkBenchTimer()
        XCTAssert(arr.interpolationSearch(15, from: 0, to: arr.count - 1) == 15)
        XCTAssert(arr.interpolationSearch(1000, from: 0, to: arr.count - 1) == 1000)
        print("Interpolation search finished working for \(measure_interpolation.stop())")
        //*Interpolation* search finished working for 2.300739288330078e-05
                
        let measure_exponential = ParkBenchTimer()
        XCTAssert(arr.exponentialSearch(15, from: 0, to: arr.count - 1) == 15)
        XCTAssert(arr.exponentialSearch(1000, from: 0, to: arr.count - 1) == 1000)
        print("Exponential search finished working for \(measure_exponential.stop())")
        //*Exponential* search finished working for 3.2067298889160156e-05
    }
}
