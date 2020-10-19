import Foundation

public func findStatistics<T: Comparable>(_ array: [T], order k: Int) -> T? {
    guard k >= array.startIndex, k < array.endIndex, !array.isEmpty else { return nil }
    var a = array
    func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
        let pivotIndex = Int.random(in: low...high)
        a.swapAt(pivotIndex, high)
        return a[high]
    }
    
    func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
        let pivot = randomPivot(&a, low, high)
        var i = low
        for j in low..<high {
            if a[j] <= pivot {
                a.swapAt(i, j)
                i += 1
            }
        }
        a.swapAt(i, high)
        return i
    }
    
    func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
        if low < high {
            let p = randomizedPartition(&a, low, high)
            if k == p {
                return a[p]
            } else if k < p {
                return randomizedSelect(&a, low, p - 1, k)
            } else {
                return randomizedSelect(&a, p + 1, high, k)
            }
        } else {
            return a[low]
        }
    }
    return randomizedSelect(&a, 0, a.count - 1, k)
}
