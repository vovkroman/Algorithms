import Foundation

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
