import Foundation

extension Array where Element: Comparable {

/** **Binary search**: is a search algorithm that finds the position of a target value within a sorted array.
Binary search compares the target value to the middle element of the array.
Current implementation is iterative implementation.
    
**Requirements**
- Element of sorted array should be Comparable. and Array should be sorted

**Application**
- efficiently solves searching problem

**Performance**:
- *worst* complexity: O(log n)
- *average* complexity: O(log n)
- *best* complexity: O(1)

- *space* complexity: O(1)*/
    @inlinable
    public func binarySearch(_ key: Element, from: Index, to: Index) -> Index? {
        var lowerBound = from
        var upperBound = to
        while lowerBound < upperBound {
            if lowerBound == upperBound {
                if self[upperBound] == key {
                    return upperBound
                } else {
                    return nil
                }
            }
            let midIndex = (lowerBound + upperBound) / 2
            if self[midIndex] == key {
                return midIndex
            } else if self[midIndex] < key {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex - 1
            }
        }
        //if target is found, otherwise nil
        if self[lowerBound] == key {
            return lowerBound
        }
        return nil
    }
}
