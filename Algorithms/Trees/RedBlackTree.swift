import Foundation

public enum Color {
    case black
    case red
}

extension Color {
    var symbol: String {
        switch self {
        case .black: return "■"
        case .red:   return "□"
        }
    }
}

public struct RedBlackTree<Element: Comparable> {
    fileprivate var root: Node? = nil
    public init() {}
}

extension RedBlackTree {
    class Node {
        var color: Color
        var value: Element
        var left: Node? = nil
        var right: Node? = nil
        var mutationCount: Int64 = 0

        init(_ color: Color, _ value: Element, _ left: Node?, _ right: Node?) {
            self.color = color
            self.value = value
            self.left = left
            self.right = right
        }
    }
}

extension RedBlackTree {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root?.forEach(body)
    }
}

extension RedBlackTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try left?.forEach(body)
        try body(value)
        try right?.forEach(body)
    }
}

extension RedBlackTree {
    public func contains(_ element: Element) -> Bool {
        var node = root
        while let n = node {
            if n.value < element {
                node = n.right
            }
            else if n.value > element {
                node = n.left
            }
            else {
                return true
            }
        }
        return false
    }
}

private func diagram<Element: Comparable>(for node: RedBlackTree<Element>.Node?, _ top: String = "", _ root: String = "", _ bottom: String = "") -> String {
    guard let node = node else {
        return root + "•\n"
    }
    if node.left == nil && node.right == nil {
        return root + "\(node.color.symbol) \(node.value)\n"
    }
    return diagram(for: node.right, top + "    ", top + "┌───", top + "│   ")
        + root + "\(node.color.symbol) \(node.value)\n"
        + diagram(for: node.left, bottom + "│   ", bottom + "└───", bottom + "    ")
}

extension RedBlackTree: CustomStringConvertible {
    public var description: String {
        return diagram(for: root)
    }
}

extension RedBlackTree.Node {
    func clone() -> RedBlackTree.Node {
        return .init(color, value, left, right)
    }
}

extension RedBlackTree {
    fileprivate mutating func makeRootUnique() -> Node? {
        if root != nil, !isKnownUniquelyReferenced(&root) {
            root = root!.clone()
        }
        return root
    }
}

extension RedBlackTree.Node {
    func makeLeftUnique() -> RedBlackTree<Element>.Node? {
        if left != nil, !isKnownUniquelyReferenced(&left) {
            left = left!.clone()
        }
        return left
    }

    func makeRightUnique() -> RedBlackTree<Element>.Node? {
        if right != nil, !isKnownUniquelyReferenced(&right) {
            right = right!.clone()
        }
        return right
    }
}

extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        guard let root = makeRootUnique() else {
            self.root = Node(.black, element, nil, nil)
            return (true, element)
        }
        defer { root.color = .black }
        return root.insert(element)
    }
}

extension RedBlackTree.Node {
    func insert(_ element: Element)  -> (inserted: Bool, memberAfterInsert: Element) {
        mutationCount += 1
        if element < self.value {
            if let next = makeLeftUnique() {
                let result = next.insert(element)
                if result.inserted { self.balance() }
                return result
            }
            else {
                self.left = .init(.red, element, nil, nil)
                return (inserted: true, memberAfterInsert: element)
            }
        }
        if element > self.value {
            if let next = makeRightUnique() {
                let result = next.insert(element)
                if result.inserted { self.balance() }
                return result
            }
            else {
                self.right = .init(.red, element, nil, nil)
                return (inserted: true, memberAfterInsert: element)
            }
        }
        return (inserted: false, memberAfterInsert: self.value)
    }
}

extension RedBlackTree.Node {
    func balance() {
        if self.color == .red  { return }
        if left?.color == .red {
            if left?.left?.color == .red {
                let l = left!
                let ll = l.left!
                swap(&self.value, &l.value)
                (self.left, l.left, l.right, self.right) = (ll, l.right, self.right, l)
                self.color = .red
                l.color = .black
                ll.color = .black
                return
            }
            if left?.right?.color == .red {
                let l = left!
                let lr = l.right!
                swap(&self.value, &lr.value)
                (l.right, lr.left, lr.right, self.right) = (lr.left, lr.right, self.right, lr)
                self.color = .red
                l.color = .black
                lr.color = .black
                return
            }
        }
        if right?.color == .red {
            if right?.left?.color == .red {
                let r = right!
                let rl = r.left!
                swap(&self.value, &rl.value)
                (self.left, rl.left, rl.right, r.left) = (rl, self.left, rl.left, rl.right)
                self.color = .red
                r.color = .black
                rl.color = .black
                return
            }
            if right?.right?.color == .red {
                let r = right!
                let rr = r.right!
                swap(&self.value, &r.value)
                (self.left, r.left, r.right, self.right) = (r, self.left, r.left, rr)
                self.color = .red
                r.color = .black
                rr.color = .black
                return
            }
        }
    }
}

private struct Weak<Wrapped: AnyObject> {
    weak var value: Wrapped?

    init(_ value: Wrapped) {
        self.value = value
    }
}

extension RedBlackTree {
    public struct Index {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64?
    
        fileprivate var path: [Weak<Node>]
    
        fileprivate init(root: Node?, path: [Weak<Node>]) {
            self.root = root
            self.mutationCount = root?.mutationCount
            self.path = path
        }
    }
}

extension RedBlackTree {
    public var endIndex: Index {
        return Index(root: root, path: [])
    }

    // - Complexity: O(log(n)); this violates `Collection` requirements.
    public var startIndex: Index {
        var path: [Weak<Node>] = []
        var node = root
        while let n = node {
            path.append(Weak(n))
            node = n.left
        }
        return Index(root: root, path: path)
    }
}

extension RedBlackTree.Index {
    fileprivate func isValid(for root: RedBlackTree<Element>.Node?) -> Bool {
        return self.root === root
            && self.mutationCount == root?.mutationCount
    }
}

extension RedBlackTree.Index {
    fileprivate static func validate(_ left: RedBlackTree<Element>.Index, _ right: RedBlackTree<Element>.Index) -> Bool {
        return left.root === right.root
            && left.mutationCount == right.mutationCount
            && left.mutationCount == left.root?.mutationCount
    }
}

extension RedBlackTree {
    public subscript(_ index: Index) -> Element {
        precondition(index.isValid(for: root))
        return index.path.last!.value!.value
    }
}

extension RedBlackTree.Index {
    /// Precondition: `self` is a valid index.
    fileprivate var current: RedBlackTree<Element>.Node? {
        guard let ref = path.last else { return nil }
        return ref.value!
    }
}

extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        precondition(RedBlackTree<Element>.Index.validate(left, right))
        return left.current === right.current
    }

    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        precondition(RedBlackTree<Element>.Index.validate(left, right))
        switch (left.current, right.current) {
        case let (a?, b?):
            return a.value < b.value
        case (nil, _):
            return false
        default:
            return true
        }
    }
}

extension RedBlackTree {
    public func formIndex(after index: inout Index) {
        precondition(index.isValid(for: root))
        index.formSuccessor()
    }

    public func index(after index: Index) -> Index {
        var result = index
        self.formIndex(after: &result)
        return result
    }
}

extension RedBlackTree.Index {
    /// Precondition: `self` is a valid index other than `endIndex`.
    mutating func formSuccessor() {
        guard let node = current else { preconditionFailure() }
        if var n = node.right {
            path.append(Weak(n))
            while let next = n.left {
                path.append(Weak(next))
                n = next
            }
        }
        else {
            path.removeLast()
            var n = node
            while let parent = self.current {
                if parent.left === n { return }
                n = parent
                path.removeLast()
            }
        }
    }
}

extension RedBlackTree {
    public func formIndex(before index: inout Index) {
        precondition(index.isValid(for: root))
        index.formPredecessor()
    }

    public func index(before index: Index) -> Index {
        var result = index
        self.formIndex(before: &result)
        return result
    }
}

extension RedBlackTree.Index {
    /// Precondition: `self` is a valid index other than `startIndex`.
    mutating func formPredecessor() {
        let current = self.current
        precondition(current != nil || root != nil)
        if var n = (current == nil ? root : current!.left) {
            path.append(Weak(n))
            while let next = n.right {
                path.append(Weak(next))
                n = next
            }
        }
        else {
            path.removeLast()
            var n = current
            while let parent = self.current {
                if parent.right === n { return }
                n = parent
                path.removeLast()
            }
        }
    }
}

extension RedBlackTree: Sequence {
    public struct Iterator: IteratorProtocol {
        let tree: RedBlackTree
        var index: RedBlackTree.Index
        
        init(_ tree: RedBlackTree) {
            self.tree = tree
            self.index = tree.startIndex
        }
    
        public mutating func next() -> Element? {
            if index.path.isEmpty { return nil }
            defer { index.formSuccessor() }
            return index.path.last!.value!.value
        }
    }
}

extension RedBlackTree {
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}
