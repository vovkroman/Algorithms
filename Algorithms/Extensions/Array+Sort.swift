import Foundation

// MARK: SQUARE SORTS

extension Array where Element: Equatable & Comparable {
    
    @inlinable
    public func selectionSort(comparison: (Element, Element) -> Bool) -> [Element] {
        guard count > 1 else { return self }
        var a = self
        for x in 0 ..< a.count - 1 {
            var lowest = x
            for y in x + 1 ..< a.count {
                if comparison(a[y], a[lowest]) {
                    lowest = y
                }
            }
            if x != lowest {
                a.swapAt(x, lowest)
            }
        }
        return a
    }
}


// MARK: QUICK SORTS

extension Array where Element: Equatable & Comparable {
    
    @inlinable
    public func quicksort(comparison: ((Element, Element) -> Bool)) -> [Element] {
        var copy = self
        copy.quick(0, count - 1, comparison: comparison)
        return copy
    }
    
    @usableFromInline
    internal mutating func quick(_ i: Int, _ j: Int, comparison: ((Element, Element) -> Bool)) {
        guard i < j else {
            return
        }
        let pivot = partition(i, j, comparison: comparison)
        quick(i, pivot - 1, comparison: comparison)
        quick(pivot + 1, j, comparison: comparison)
    }
    
    @usableFromInline
    internal mutating func partition(_ i: Int, _ j: Int, comparison: ((Element, Element) -> Bool)) -> Int {
        let pivotElement = self[j]
        var indexToAdd = i - 1
        for k in i..<j {
            if comparison(self[k], pivotElement) {
                indexToAdd += 1
                swapAt(indexToAdd, k)
            }
        }
        swapAt(indexToAdd + 1, j)
        return indexToAdd + 1
    }
}

extension Array where Element: Equatable & Comparable {
    @inlinable
    public func mergesort(comparison: ((Element, Element) -> Bool)) -> [Element] {
        return merge(0, count - 1, comparison: comparison)
    }

    @usableFromInline
    internal func merge(_ i: Int, _ j: Int, comparison: ((Element, Element) -> Bool)) -> [Element] {
        guard i <= j else {
            return []
        }
        guard i != j else {
            return [self[i]]
        }
        let half = i + (j - i) / 2
        let left = merge(i, half, comparison: comparison)
        let right = merge(half + 1, j, comparison: comparison)
        var i1 = 0
        var i2 = 0
        var new = [Element]()
        new.reserveCapacity(left.count + right.count)
        while i1 < left.count && i2 < right.count {
            if comparison(right[i2], left[i1]) {
                new.append(right[i2])
                i2 += 1
            } else {
                new.append(left[i1])
                i1 += 1
            }
        }
        while i1 < left.count {
            new.append(left[i1])
            i1 += 1
        }
        while i2 < right.count {
            new.append(right[i2])
            i2 += 1
        }
        return new
    }
}
