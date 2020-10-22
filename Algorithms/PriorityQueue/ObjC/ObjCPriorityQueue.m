#import "ObjCPriorityQueue.h"
#import "Defines.h"

static const void *heap_retain(CFAllocatorRef allocator, const void *ptr) {
    return (const void *)CFRetain((CFTypeRef)ptr);
}

static void heap_release(CFAllocatorRef allocator, const void *ptr) {
    CFRelease((CFTypeRef)ptr);;
}

static CFComparisonResult heap_compare(const void *ptr1, const void *ptr2, void *unused) {
    return (CFComparisonResult)[(__bridge id<ObjCComparableProtocol>)ptr1 compare:(__bridge id<ObjCComparableProtocol>)ptr2];
}

static void heap_apply(const void *val, void *context) {
    void (^block)(id object) = (__bridge void (^)(__strong id))(context);
    if (block) {
        block((__bridge id)(val));
    }
}

@implementation ObjCPriorityQueue {
    CFBinaryHeapRef _heap;
}

- (void)enqueue:(id)object {
    CFBinaryHeapAddValue(_heap, (__bridge const void *)object);
}

- (nullable id)dequeue {
    let object = (id)CFBinaryHeapGetMinimum(_heap);
    CFBinaryHeapRemoveMinimumValue(_heap);
    return object;
}

- (NSUInteger)count {
    return CFBinaryHeapGetCount(_heap);
}

- (NSUInteger)countOfObject:(id)object {
    return CFBinaryHeapGetCountOfValue(_heap, (__bridge const void *)(object));
}

- (BOOL)contains:(id)object {
    return CFBinaryHeapContainsValue(_heap, (__bridge const void *)object);
}

- (void)dealloc {
    CFRelease(_heap);
}

- (void)enumerateObjectsUsingBlock:(ApplyBlock)block {
    void *context = (__bridge void *)(block);
    CFBinaryHeapApplyFunction(_heap, heap_apply, context);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CFBinaryHeapCallBacks callBacks = {0, heap_retain, heap_release, NULL, heap_compare};
        _heap = CFBinaryHeapCreate(NULL, 0, &callBacks, NULL);
    }
    return self;
}

@end
