//
//  Heap_NIO.swift
//  Algorithms
//
//  Created by Roman Vovk on 12.05.2021.
//  Copyright © 2021 Roman Vovk. All rights reserved.
//

import Foundation

public enum NIO {}

extension NIO {
    @usableFromInline
    internal struct Heap<Element: Comparable> {
        @usableFromInline
        internal private(set) var storage: ContiguousArray<Element> = []

        @usableFromInline
        internal init() {}

        internal func comparator(_ lhs: Element, _ rhs: Element) -> Bool {
            // This heap is always a min-heap.
            return lhs < rhs
        }

        // named `PARENT` in CLRS
        private func parentIndex(_ i: Int) -> Int {
            return (i-1) / 2
        }

        // named `LEFT` in CLRS
        internal func leftIndex(_ i: Int) -> Int {
            return 2*i + 1
        }

        // named `RIGHT` in CLRS
        internal func rightIndex(_ i: Int) -> Int {
            return 2*i + 2
        }

        // named `MAX-HEAPIFY` in CLRS
        private mutating func heapify(_ index: Int) {
            let left = self.leftIndex(index)
            let right = self.rightIndex(index)

            var root: Int
            if left <= (self.storage.count - 1) && self.comparator(storage[left], storage[index]) {
                root = left
            } else {
                root = index
            }

            if right <= (self.storage.count - 1) && self.comparator(storage[right], storage[root]) {
                root = right
            }

            if root != index {
                self.storage.swapAt(index, root)
                self.heapify(root)
            }
        }

        // named `HEAP-INCREASE-KEY` in CRLS
        private mutating func heapRootify(index: Int, key: Element) {
            var index = index
            if self.comparator(storage[index], key) {
                fatalError("New key must be closer to the root than current key")
            }

            self.storage[index] = key
            while index > 0 && self.comparator(self.storage[index], self.storage[self.parentIndex(index)]) {
                self.storage.swapAt(index, self.parentIndex(index))
                index = self.parentIndex(index)
            }
        }

        @usableFromInline
        internal mutating func append(_ value: Element) {
            var i = self.storage.count
            self.storage.append(value)
            while i > 0 && self.comparator(self.storage[i], self.storage[self.parentIndex(i)]) {
                self.storage.swapAt(i, self.parentIndex(i))
                i = self.parentIndex(i)
            }
        }

        @discardableResult
        @usableFromInline
        internal mutating func removeRoot() -> Element? {
            return self.remove(index: 0)
        }

        @discardableResult
        @usableFromInline
        internal mutating func remove(value: Element) -> Bool {
            if let idx = self.storage.firstIndex(of: value) {
                self.remove(index: idx)
                return true
            } else {
                return false
            }
        }

        @discardableResult
        private mutating func remove(index: Int) -> Element? {
            guard self.storage.count > 0 else {
                return nil
            }
            let element = self.storage[index]
            if self.storage.count == 1 || self.storage[index] == self.storage[self.storage.count - 1] {
                self.storage.removeLast()
            } else if !self.comparator(self.storage[index], self.storage[self.storage.count - 1]) {
                self.heapRootify(index: index, key: self.storage[self.storage.count - 1])
                self.storage.removeLast()
            } else {
                self.storage[index] = self.storage[self.storage.count - 1]
                self.storage.removeLast()
                self.heapify(index)
            }
            return element
        }
    }

}
extension NIO.Heap: CustomDebugStringConvertible {
    @usableFromInline
    var debugDescription: String {
        guard self.storage.count > 0 else {
            return "<empty heap>"
        }
        let descriptions = self.storage.map { String(describing: $0) }
        let maxLen: Int = descriptions.map { $0.count }.max()! // storage checked non-empty above
        let paddedDescs = descriptions.map { (desc: String) -> String in
            var desc = desc
            while desc.count < maxLen {
                if desc.count % 2 == 0 {
                    desc = " \(desc)"
                } else {
                    desc = "\(desc) "
                }
            }
            return desc
        }

        var all = "\n"
        let spacing = String(repeating: " ", count: maxLen)
        func subtreeWidths(rootIndex: Int) -> (Int, Int) {
            let lcIdx = self.leftIndex(rootIndex)
            let rcIdx = self.rightIndex(rootIndex)
            var leftSpace = 0
            var rightSpace = 0
            if lcIdx < self.storage.count {
                let sws = subtreeWidths(rootIndex: lcIdx)
                leftSpace += sws.0 + sws.1 + maxLen
            }
            if rcIdx < self.storage.count {
                let sws = subtreeWidths(rootIndex: rcIdx)
                rightSpace += sws.0 + sws.1 + maxLen
            }
            return (leftSpace, rightSpace)
        }
        for (index, desc) in paddedDescs.enumerated() {
            let (leftWidth, rightWidth) = subtreeWidths(rootIndex: index)
            all += String(repeating: " ", count: leftWidth)
            all += desc
            all += String(repeating: " ", count: rightWidth)

            func height(index: Int) -> Int {
                return Int(log2(Double(index + 1)))
            }
            let myHeight = height(index: index)
            let nextHeight = height(index: index + 1)
            if myHeight != nextHeight {
                all += "\n"
            } else {
                all += spacing
            }
        }
        all += "\n"
        return all
    }
}

extension NIO {
    @usableFromInline
    struct HeapIterator<Element: Comparable>: IteratorProtocol {
        private var heap: Heap<Element>

        init(heap: Heap<Element>) {
            self.heap = heap
        }

        @usableFromInline
        mutating func next() -> Element? {
            return self.heap.removeRoot()
        }
    }
}

extension NIO.Heap: Sequence {
    var startIndex: Int { return self.storage.startIndex }
    var endIndex: Int { return self.storage.endIndex }

    @usableFromInline
    var underestimatedCount: Int {
        return self.storage.count
    }

    @usableFromInline
    func makeIterator() -> NIO.HeapIterator<Element> {
        return NIO.HeapIterator(heap: self)
    }

    subscript(position: Int) -> Element {
        return self.storage[position]
    }

    func index(after i: Int) -> Int {
        return i + 1
    }

    var count: Int {
        return self.storage.count
    }
}
