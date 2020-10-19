import Foundation

public func selectionSort<T: Comparable>(_ array: inout [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else { return array }
    var a = array
    for x in 0 ..< a.count - 1 {
        // Find the lowest value in the rest of the array.
        var lowest = x
        for y in x + 1 ..< a.count {
            if isOrderedBefore(a[y], a[lowest]) {
                lowest = y
            }
        }
        
        if x != lowest {
            a.swapAt(x, lowest)
        }
    }
    return a
}
