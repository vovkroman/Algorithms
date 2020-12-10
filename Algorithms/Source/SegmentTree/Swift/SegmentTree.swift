import Foundation
/** **Segment tree**: is a tree data structure used for storing information about intervals,
 or segments. It allows querying which of the stored segments contain a given point.
 It is, in principle, a static structure; that is,
 it's a structure that cannot be modified once it's built.
 
**Requirements**
 - function should be associative (**associative rule**: (x ∗ y) ∗ z = x ∗ (y ∗ z)).
 
 For example, the function can be sum, multiplication, min, max, gcd, and so on.
 
**Application**
 - Can be efficient on RMQ problem
 
**Performance**:
 - building the tree is O(n)
 - query is O(log n)
 - replace item is O(log n)

**Drawback**:
 - Memory is 4*n for array of n **/
public class SegmentTree<T> {

    @usableFromInline
    internal var value: T
    
    @usableFromInline
    internal var function: (T, T) -> T
    
    @usableFromInline
    internal var leftBound: Int
    
    @usableFromInline
    internal var rightBound: Int
    
    @usableFromInline
    internal var leftChild: SegmentTree<T>?
    
    @usableFromInline
    internal var rightChild: SegmentTree<T>?

    @usableFromInline
    internal init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.function = function

        if leftBound == rightBound {
            value = array[leftBound]
        } else {
            let middle = (leftBound + rightBound) / 2
            leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
            rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
            value = function(leftChild!.value, rightChild!.value)
        }
    }
    
    /// Description: initialize Segment Tree with array and some associative function *f* (s. Descritpion).
    /// Complexity: O(n)
    /// - Parameters:
    ///   - array: array
    ///   - function: operation that should be applied to all elements of array
    @inlinable
    public convenience init(array: [T], function: @escaping (T, T) -> T) {
        self.init(array: array, leftBound: 0, rightBound: array.count-1, function: function)
    }
    
    /// Description: Perform query, for common interval, that defines with range [leftBound, rightBound]. Complexity: O(log(n))
    /// - Parameters:
    ///   - leftBound: left bounded index
    ///   - rightBound: right bounded index
    @inlinable
    public func query(leftBound: Int, rightBound: Int) -> T {
        if self.leftBound == leftBound && self.rightBound == rightBound {
            return self.value
        }

        guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }

        if leftChild.rightBound < leftBound {
            return rightChild.query(leftBound: leftBound, rightBound: rightBound)
        } else if rightChild.leftBound > rightBound {
            return leftChild.query(leftBound: leftBound, rightBound: rightBound)
        } else {
            let leftResult = leftChild.query(leftBound: leftBound, rightBound: leftChild.rightBound)
            let rightResult = rightChild.query(leftBound:rightChild.leftBound, rightBound: rightBound)
            return function(leftResult, rightResult)
        }
    }
    
    /// Description: Perform replacing item at index (perform replacing and recalculate all affected items).
    /// Complexity: O(log(n))
    /// - Parameters:
    ///   - index: index of element to be replaced
    ///   - item: replaced element
    @inlinable
    public func replaceItem(at index: Int, withItem item: T) {
        if leftBound == rightBound {
            value = item
        } else if let leftChild = leftChild, let rightChild = rightChild {
            if leftChild.rightBound >= index {
                leftChild.replaceItem(at: index, withItem: item)
            } else {
                rightChild.replaceItem(at: index, withItem: item)
            }
            value = function(leftChild.value, rightChild.value)
        }
    }
}
