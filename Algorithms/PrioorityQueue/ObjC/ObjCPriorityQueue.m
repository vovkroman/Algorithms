#import "ObjCPriorityQueue.h"
#import "Defines.h"

CF_INLINE const void *PQRetain(CFAllocatorRef allocator, const void *ptr) {
  return (__bridge_retained const void *)(__bridge id)ptr;
}

CF_INLINE const void PQRelease(CFAllocatorRef allocator, const void *ptr) {
  (void)(__bridge_transfer id)ptr;
}

CF_INLINE const CFComparisonResult PQCompare(const void *ptr1, const void *ptr2, void *unused) {
  return (CFComparisonResult)[(__bridge id)ptr1 compare:(__bridge id)ptr2];
}

@implementation ObjCPriorityQueue {
    CFBinaryHeapRef _pq;
}

- (void)enqueue:(id)object {
    CFBinaryHeapAddValue(_pq, (__bridge const void *)object);
}

- (nullable id)dequeue {
    let object = (id)CFBinaryHeapGetMinimum(_pq);
    CFBinaryHeapRemoveMinimumValue(_pq);
    return object;
}

- (CFIndex)count {
    return CFBinaryHeapGetCount(_pq);
}

- (BOOL)contains:(id)object {
    return CFBinaryHeapContainsValue(_pq, (__bridge const void *)object);
}

- (void)dealloc {
    CFRelease(_pq);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CFBinaryHeapCallBacks callBacks = {0, PQRetain, PQRelease, NULL, PQCompare};
        _pq = CFBinaryHeapCreate(NULL, 0, &callBacks, NULL);
    }
    return self;
}

@end
