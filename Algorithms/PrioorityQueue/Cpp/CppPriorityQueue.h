#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* Determines how to compare two nodes in the heap.
* Use 'OrderedDescending' for a max-heap or 'OrderedAscending' for a min-heap,
*/
typedef NS_CLOSED_ENUM(NSInteger, ComparisonResult) {
    /// The left operand is smaller than the right operand.
    OrderedAscending = -1L,
    /// The left operand is greater than the right operand.
    OrderedDescending
};

/**
* Priority Queue, a queue where the most "important" items are at the front of
* the queue.
 
* The heap is a natural data structure for a priority queue, so this object
* simply wraps the Heap struct.
 
* All operations are O(lg n).

* Just like a heap can be a max-heap or min-heap, the queue can be a max-priority
* queue (largest element first) or a min-priority queue (smallest element first).
*/

@interface CppPriorityQueue<__covariant ObjectType> : NSObject

- (size_t)count;
- (void)enqueue:(ObjectType)obj value:(unsigned)val;
- (nullable ObjectType)dequeue; 
- (BOOL)isEmpty;

#pragma mark - Initialization
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init:(ComparisonResult)comparationResult;

@end

NS_ASSUME_NONNULL_END
