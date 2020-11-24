import Foundation

/**
 Description: *Result* represents result
 on searching element in ordered array
 
 Available cases:
 - **success(index:**: element contains in any storage (ordered array, set etc) by index
 - **failure**: element doesn't contain in ordered array
 */
public enum Result<T> {
    case success(index: T) // element does contain in the array
    case failure // element doesn't contain in the array
}

public protocol Keyable {
    associatedtype KeyType: Comparable
    var key: KeyType { get }
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
