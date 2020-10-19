//
//  ObjCPriorityQueue.h
//  Algorithms
//
//  Created by Roman Vovk on 16.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ObjCComparableProtocol <NSObject>

- (CFComparisonResult)compare:(id)otherObject;

@end


@interface ObjCPriorityQueue<__covariant ObjectType: id<ObjCComparableProtocol>> : NSObject

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
