/**
 * An ordered array represets wrapper arround array with unique element.
 * When you add a new item to this array, it is inserted in
 * sorted position and checked if array contains such element by comparable key
 **/
import Foundation

public enum Result {
    case success(index: Int) // element does contain in the array
    case failure // element doesn't contain in the array
}

public struct OrderedArray<T: Keyable> {
    
    public typealias ComparatorType = (T, T) -> Bool
    
    private var array: ContiguousArray<T> = []
    
    public init(array: [T] = [], comparator:  ComparatorType = { $0.key < $1.key })  {
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
        let index = findInsertionPoint(by: newElement.key)
        if index >= 0, index < array.count, array[index].key == newElement.key { return }
        var insertIndex = index
        if array[index].key < newElement.key { insertIndex += 1 }
        array.insert(newElement, at: insertIndex)
    }
    
    @inline(__always)
    public func lookUp<T: Comparable>(of key: T) -> Result where Element.KeyType == T {
        let index = findInsertionPoint(by: key)
        if index >= 0, index < array.count, array[index].key == key {
            return .success(index: index)
        } else {
            return .failure
        }
    }
    
    /**
     *
     **/
    private func findInsertionPoint<T: Comparable>(by key: T) -> Int where Element.KeyType == T {
        var startIndex = 0
        var endIndex = array.count - 1
        
        while startIndex < endIndex {
            let midIndex = startIndex + (endIndex - startIndex) / 2
            if array[midIndex].key == key {
                return midIndex
            } else if array[midIndex].key < key {
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
