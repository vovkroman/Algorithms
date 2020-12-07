import Foundation

extension Array where Element: Comparable {
    /// Description: extenstion to [Array](https://developer.apple.com/documentation/swift/array) to
    /// find index of the largest element in unsorted array
    /// - Compexity: O(n)
    @inlinable
    public func argmax() -> Index? {
        return indices.max(by: { self[$0] < self[$1] })
    }
    
    /// Description: extenstion to [Array](https://developer.apple.com/documentation/swift/array) to
    /// find index of the smallest element in unsorted array
    /// - Compexity: O(n)
    @inlinable
    public func argmin() -> Index? {
        return indices.min(by: { self[$0] < self[$1] })
    }
}

extension Array {
    /// Description: extension to [Array](https://developer.apple.com/documentation/swift/array)
    /// to find index of the biggest element that satisfying specific condition (set by *areInIncreasingOrder*)
    /// - Parameter areInIncreasingOrder: closure to set condition
    @inlinable
    public func argmax(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.max { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
    
    /// Description: extension to [Array](https://developer.apple.com/documentation/swift/array)
      /// to find index of the smallest element that satisfying specific condition (set by *areInIncreasingOrder*)
      /// - Parameter areInIncreasingOrder: closure to set condition
    @inlinable
    public func argmin(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.min { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
}
