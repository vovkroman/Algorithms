import Foundation

extension Set {
    
    /// Description: Searching element in set
    /// - Parameter element: element to be searched
    /// - Complexity: O(1);
    @inlinable
    public func lookUp(of element: Element) -> Result<Set<Element>.Index> {
        guard let index = firstIndex(of: element) else {
            return .failure
        }
        return .success(index: index)
    }
}
