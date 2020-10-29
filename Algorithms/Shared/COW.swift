import Foundation

/** **COW** file contains some routines
 * for working with COW semantic optimization technics
 **/
public final class Ref<T> {
    public var value: T
    
    public init(value: T) {
        self.value = value
    }
}

public struct Box<T> {
    private var ref: Ref<T>
    
    public init(value: T) {
        ref = Ref(value: value)
    }

    public var value: T {
        get { return ref.value }
        set {
            guard isKnownUniquelyReferenced(&ref) else {
                ref = Ref(value: newValue)
                return
            }
            ref.value = newValue
        }
    }
}
