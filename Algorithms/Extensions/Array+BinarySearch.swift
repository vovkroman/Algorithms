import Foundation

/**
 The iterative version of binary search.
 **/

extension Array where Element: Keyable {
    
    @inlinable
    public func binarySearch<T: Comparable>(_ key: T) -> Index? where Element.KeyType == T {
        var lowerBound = 0
        var upperBound = count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if self[midIndex].key == key {
                return midIndex
            } else if self[midIndex].key < key {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
}
