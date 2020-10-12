/**
 * An ordered array represets wrapper arround array with unique element.
 * When you add a new item to this array, it is inserted in
 * sorted position.
 **/
import Foundation

public enum Result {
    case success(index: Int) // element does contain in the array
    case failure // element doesn't contain in the array
}

public struct OrderedArray<T: Comparable> {
    
    public typealias ComparatorType = (T, T) -> Bool
    
    private var array: ContiguousArray<T> = []
    
    public init(array: [T] = [], comparator:  ComparatorType = { $0 < $1 })  {
        self.array = ContiguousArray<T>(array.sorted(by: comparator))
    }
    
    @inline(__always)
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    @inline(__always)
    public var count: Int {
        return array.count
    }
    
    @inline(__always)
    public subscript(index: Int) -> T {
        return array[index]
    }
    
    @inline(__always)
    public mutating func removeAtIndex(index: Int) -> T {
        return array.remove(at: index)
    }
    
    @inline(__always)
    public mutating func removeAll() {
        array.removeAll()
    }
    
    @inline(__always)
    public mutating func insert(newElement: T) {
        if array.isEmpty {
            array.append(newElement)
            return
        }
        let index = findInsertionPoint(newElement)
        if index >= 0, index < array.count, array[index] == newElement { return }
        var insertIndex = index
        if array[index] < newElement { insertIndex += 1 }
        array.insert(newElement, at: insertIndex)
    }
    
    @inline(__always)
    public func lookUp(of element: T) -> Result {
        let index = findInsertionPoint(element)
        if index >= 0, index < array.count, array[index] == element {
            return .success(index: index)
        } else {
            return .failure
        }
    }
    
    /**
     *
     **/
    private func findInsertionPoint(_ newElement: T) -> Int {
        var startIndex = 0
        var endIndex = array.count - 1
        
        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if array[midIndex] == newElement {
                return midIndex
            } else if array[midIndex] < newElement {
                startIndex = midIndex + 1
            } else {
                endIndex = midIndex
            }
        }
        return startIndex
    }
}

extension OrderedArray: Sequence {
    
    public typealias Element = T

    @inline(__always)
    public func makeIterator() -> IndexingIterator<ContiguousArray<T>> {
        return array.makeIterator()
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}

#if os(iOS)
import UIKit

extension PlaygroundQuickLook {
    public static func monospacedText(_ string: String) -> PlaygroundQuickLook {
        let text = NSMutableAttributedString(string: string)
        let range = NSRange(location: 0, length: text.length)
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.lineSpacing = 0
        style.alignment = .left
        style.maximumLineHeight = 17
        text.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Menlo", size: 13)!, range: range)
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        return PlaygroundQuickLook.attributedString(text)
    }
}
#endif

extension OrderedArray {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        #if os(iOS)
        return .monospacedText(String(describing: self))
        #else
        return .text(String(describing: self))
        #endif
    }
}
