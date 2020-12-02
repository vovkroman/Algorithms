#import <Foundation/Foundation.h>
/**
* **CFPriorityQueue**: is a data structure similar to a regular queue data structure in which each
* element additionally has a "priority" associated with it.
* In a priority queue, an element with high priority (max heap) is served before an element with low priority (min heap).
*
***Requirements**
*- Element that enqueued into priority queue should implement protocol ObjCComparableProtocol (to define compare rule)
**/
NS_ASSUME_NONNULL_BEGIN

@protocol CFComparableProtocol <NSObject>

- (CFComparisonResult)compare:(id)otherObject NS_REFINED_FOR_SWIFT;

@end


@interface CFPriorityQueue<__covariant ObjectType: id<CFComparableProtocol>>: NSObject

typedef void (^ApplyBlock)(ObjectType object);

- (void)enqueue:(ObjectType)object;
- (nullable ObjectType)dequeue;
- (NSUInteger)count;
- (NSUInteger)countOfObject:(ObjectType)object;
- (BOOL)contains:(ObjectType)object;
- (void)enumerateObjectsUsingBlock:(ApplyBlock)block;

#pragma mark - Initialization
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
