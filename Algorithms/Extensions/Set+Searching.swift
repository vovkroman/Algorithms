import Foundation

extension Set {
    
    /**
     Searching element in set
     - parameter element: element
     - returns: **Result** (see: Result)
     - Complexity: O(1)
     */
    @inlinable
    public func lookUp(of element: Element) -> Result<Set<Element>.Index> {
        guard let index = firstIndex(of: element) else {
            return .failure
        }
        return .success(index: index)
    }
}
