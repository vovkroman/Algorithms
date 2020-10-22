import Foundation

class OrderedSet<T: Hashable>: Sequence {
    private let _set = NSMutableOrderedSet()
    init() {}

    func makeIterator() -> NSFastEnumerationIterator {
        return _set.makeIterator()
    }

    func add(_ element: T) {
        _set.add(element)
    }

    func remove(_ element: T) {
        _set.remove(element)
    }
}
