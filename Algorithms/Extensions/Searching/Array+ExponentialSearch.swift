import Foundation

/** **Exponential  search**: is a search algorithm that finds the position of a target value within a sorted array.
 * Exponential  search is trying to decrease range of element position, by multiply low bound by 2. After call binary search (*See** Binary Search ).
 * Current implementation is iterative implementation.
*
***Requirements**
*- Element of sorted array should be Comparable. and Array should be sorted

 ***Application**
* - efficiently solves searching problem

***Performance**:
* - *worst* complexity: O(log n)
* - *average* complexity: O(log n)
* - *best* complexity: O(1)

* - *space* complexity: O(1)
**/

extension Array where Element: Comparable {
    
    @inlinable
    public func exponentialSearch(_ key: Element, from: Index, to: Index) -> Index? {
        if from == to {
            if self[from] == key {
                return from
            } else {
                return nil
            }
        }
        var i = 1
        while i < (to - from) && self[i] <= key { //when array[i] crosses the key element
            i *= 2 //i will increase as power of 2
        }
        return binarySearch(key, from: i / 2, to: Swift.min(i, count - 1)) //search item in the smaller range
    }
}
