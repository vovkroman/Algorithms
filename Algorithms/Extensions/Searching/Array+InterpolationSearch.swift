import Foundation

/** **Interpolation search**: is an algorithm for searching for a key in an array
 * that has been ordered by numerical values assigned to the keys (key values)..
 * Current implementation is iterative implementation.
*
***Requirements**
*- Element of sorted array should be Comparable. and Array should be sorted. Could be very efficient if the elements are uniformly distributed.

 ***Application**
* - efficiently solves searching problem.
* On average the interpolation search makes about log(log(n)) comparisons (if the elements are uniformly distributed)

***Performance**:
* - *worst* complexity: O(n)
* - *average* complexity: O(log(log(*n*)))
* - *best* complexity: O(1)

* - *space* complexity: O(1)
**/

extension Array where Element == Int {

    @inlinable
    public func interpolationSearch(_ key: Element, from: Index, to: Index) -> Index? {
        var low = from
        var high = to
        while low <= high && key >= self[low] && key <= self[high] {
            if low == high {
                if self[high] == key {
                    return high
                } else {
                    return nil
                }
            }
            let position = low + (key - self[low]) * (high - low) / (self[high] - self[low])
            if self[position] == key {
                return position
            } else if self[position] < key {
                low = position + 1
            } else {
                high = position - 1
            }
        }
        //if target is found, otherwise nil
        if self[low] == key {
            return low
        }
        return nil
    }
}
