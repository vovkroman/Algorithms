import Foundation
import Accelerate

extension Array where Element == Double {
    
    /// Description: extenstion to [Array](https://developer.apple.com/documentation/swift/array) to
    /// find index of the largest element in unsorted array (optimized by using [Accelerate](https://developer.apple.com/documentation/accelerate))
    /// - Compexity: O(n)
    /// - Application: Can't be very efficient on the great number of items
    @inlinable
    public func argmax() -> Index? {
        var elem = 0.0
        var vdspIndex: vDSP_Length = 0
        vDSP_maxviD(self, 1, &elem, &vdspIndex, vDSP_Length(count))
        let idx = Index(vdspIndex)
        return idx
    }
    
    /// Description: extenstion to [Array](https://developer.apple.com/documentation/swift/array) to
    /// find index of the smallest  element in unsorted array (optimized by using [Accelerate](https://developer.apple.com/documentation/accelerate))
    /// - Compexity: O(n)
    /// - Application: Can't be very efficient on the great number of items
    @inlinable
    public func argmin() -> Index? {
        var elem = 0.0
        var vdspIndex: vDSP_Length = 0
        vDSP_minviD(self, 1, &elem, &vdspIndex, vDSP_Length(count))
        let idx = Index(vdspIndex)
        return idx
    }
}

